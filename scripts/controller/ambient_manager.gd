## AmbientManager — Controls idle animations and ambient behavior of bots.
class_name AmbientManager
extends Node

signal bot_state_changed(bot_id: String, state: BotConfig.State)

@export var idle_interval_min: float = 4.0
@export var idle_interval_max: float = 8.0
@export var walk_interval_min: float = 30.0
@export var walk_interval_max: float = 60.0

var _bots: Dictionary = {}  # id -> BotConfig
var _timers: Dictionary = {}  # id -> SceneTreeTimer


func register_bot(bot: BotConfig) -> void:
	_bots[bot.id] = bot
	_schedule_idle(bot.id)


func unregister_bot(bot_id: String) -> void:
	_bots.erase(bot_id)
	_timers.erase(bot_id)


func _schedule_idle(bot_id: String) -> void:
	if not _bots.has(bot_id):
		return
	var delay := randf_range(idle_interval_min, idle_interval_max)
	var timer := get_tree().create_timer(delay)
	timer.timeout.connect(func() -> void: _trigger_idle(bot_id))


func _trigger_idle(bot_id: String) -> void:
	if not _bots.has(bot_id):
		return
	var bot: BotConfig = _bots[bot_id]
	if bot.state == BotConfig.State.IDLE:
		bot.state = BotConfig.State.WORKING
		bot_state_changed.emit(bot_id, BotConfig.State.WORKING)

		# Return to idle after a short work animation
		var work_timer := get_tree().create_timer(2.0)
		work_timer.timeout.connect(func() -> void:
			if _bots.has(bot_id):
				var b: BotConfig = _bots[bot_id]
				b.state = BotConfig.State.IDLE
				bot_state_changed.emit(bot_id, BotConfig.State.IDLE)
		)

	_schedule_idle(bot_id)


func set_bot_talking(bot_id: String, talking: bool) -> void:
	if not _bots.has(bot_id):
		return
	var bot: BotConfig = _bots[bot_id]
	if talking:
		bot.state = BotConfig.State.TALKING
	else:
		bot.state = BotConfig.State.IDLE
	bot_state_changed.emit(bot_id, bot.state)
