## BotConfig — Data class for a cantina bot character.
class_name BotConfig
extends Resource

enum Provider { HERMES_API, OPENROUTER }
enum State { IDLE, TALKING, WALKING, WORKING, MEETING }

@export var id: String = ""
@export var real_name: String = ""          # e.g. "Maestro"
@export var display_name: String = ""        # e.g. "Sheriff Mason"
@export var role: String = ""                # e.g. "sheriff"
@export var system_prompt: String = ""
@export var position: Vector2 = Vector2.ZERO
@export var provider: Provider = Provider.OPENROUTER
@export var model: String = "xiaomi/mimo-v2.6-pro"
@export var sprite_path: String = ""
@export var zone: String = ""                # e.g. "door", "bar", "piano"

var state: State = State.IDLE


static func from_dict(data: Dictionary) -> BotConfig:
	var bot := BotConfig.new()
	bot.id = data.get("id", "")
	bot.real_name = data.get("real_name", "")
	bot.display_name = data.get("display_name", "")
	bot.role = data.get("role", "")
	bot.system_prompt = data.get("system_prompt", "")
	var pos: Dictionary = data.get("position", {})
	bot.position = Vector2(pos.get("x", 0), pos.get("y", 0))
	var prov: String = data.get("provider", "openrouter")
	bot.provider = Provider.HERMES_API if prov == "hermes_api" else Provider.OPENROUTER
	bot.model = data.get("model", "xiaomi/mimo-v2.6-pro")
	bot.sprite_path = data.get("sprite", "")
	bot.zone = data.get("zone", "")
	return bot
