## Config — Autoload singleton for app configuration and settings.
## API keys are loaded from environment, NEVER hardcoded.
extends Node

signal settings_changed

# --- API endpoints ---
const HERMES_API_URL := "http://localhost:8642/v1"
const OPENROUTER_API_URL := "https://openrouter.ai/api/v1"

# --- API keys (from environment or .env, never in repo) ---
var hermes_api_key: String = ""
var openrouter_api_key: String = ""

# --- Audio settings ---
var music_volume: float = 0.5
var sfx_volume: float = 0.7
var music_enabled: bool = true
var sfx_enabled: bool = true

# --- Display ---
var player_name: String = "David"

# --- Rate limiting ---
var max_messages_per_minute: int = 10


func _ready() -> void:
	_load_api_keys()
	_load_settings()


func _load_api_keys() -> void:
	hermes_api_key = OS.get_environment("HERMES_API_KEY")
	openrouter_api_key = OS.get_environment("OPENROUTER_API_KEY")

	# Fallback: .env file in user directory
	if hermes_api_key.is_empty():
		hermes_api_key = _read_env_value("HERMES_API_KEY")
	if openrouter_api_key.is_empty():
		openrouter_api_key = _read_env_value("OPENROUTER_API_KEY")


func _read_env_value(key: String) -> String:
	var env_path := "user://.env"
	if not FileAccess.file_exists(env_path):
		return ""
	var file := FileAccess.open(env_path, FileAccess.READ)
	if file == null:
		return ""
	while not file.eof_reached():
		var line := file.get_line()
		if line.begins_with(key + "="):
			return line.substr(key.length() + 1).strip_edges()
	return ""


func _load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load("user://settings.cfg")
	if err != OK:
		return
	music_volume = config.get_value("audio", "music_volume", music_volume)
	sfx_volume = config.get_value("audio", "sfx_volume", sfx_volume)
	music_enabled = config.get_value("audio", "music_enabled", music_enabled)
	sfx_enabled = config.get_value("audio", "sfx_enabled", sfx_enabled)
	player_name = config.get_value("player", "name", player_name)


func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.set_value("audio", "music_enabled", music_enabled)
	config.set_value("audio", "sfx_enabled", sfx_enabled)
	config.set_value("player", "name", player_name)
	config.save("user://settings.cfg")
	settings_changed.emit()


func set_music_volume(value: float) -> void:
	music_volume = clampf(value, 0.0, 1.0)
	save_settings()


func set_sfx_volume(value: float) -> void:
	sfx_volume = clampf(value, 0.0, 1.0)
	save_settings()


func toggle_music() -> void:
	music_enabled = not music_enabled
	save_settings()


func toggle_sfx() -> void:
	sfx_enabled = not sfx_enabled
	save_settings()
