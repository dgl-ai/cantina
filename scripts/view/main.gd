## Main — Main scene controller for the Cantina.
extends Node2D

@onready var _bots: Dictionary = {}
var _ambient_manager: AmbientManager
var _hermes_api: HermesAPI
var _openrouter_api: OpenRouterAPI


func _ready() -> void:
	_setup_controllers()
	_load_bots()
	print("[Cantina] Loaded ", _bots.size(), " bots")


func _setup_controllers() -> void:
	_ambient_manager = AmbientManager.new()
	add_child(_ambient_manager)
	_ambient_manager.bot_state_changed.connect(_on_bot_state_changed)

	_hermes_api = HermesAPI.new()
	_hermes_api.configure(Config.HERMES_API_URL, Config.hermes_api_key)
	add_child(_hermes_api)

	_openrouter_api = OpenRouterAPI.new()
	_openrouter_api.configure(Config.openrouter_api_key)
	add_child(_openrouter_api)


func _load_bots() -> void:
	var file := FileAccess.open("res://data/bots.json", FileAccess.READ)
	if file == null:
		push_error("[Cantina] Cannot open bots.json")
		return

	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	if err != OK:
		push_error("[Cantina] Failed to parse bots.json")
		return

	var bots_array: Array = json.data
	for data in bots_array:
		var bot := BotConfig.from_dict(data)
		_bots[bot.id] = bot
		_ambient_manager.register_bot(bot)


func _on_bot_state_changed(bot_id: String, state: BotConfig.State) -> void:
	# Future: update sprite animation based on state
	pass


func send_message_to_bot(bot_id: String, message: String) -> void:
	if not _bots.has(bot_id):
		push_warning("[Cantina] Unknown bot: " + bot_id)
		return

	var bot: BotConfig = _bots[bot_id]
	_ambient_manager.set_bot_talking(bot_id, true)

	match bot.provider:
		BotConfig.Provider.HERMES_API:
			_hermes_api.send_chat(message, bot.system_prompt)
		BotConfig.Provider.OPENROUTER:
			_openrouter_api.send_chat(message, bot.system_prompt, bot.model)
