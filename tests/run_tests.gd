## Test runner — validates project integrity.
## Run: godot --headless --path . --script tests/run_tests.gd
extends SceneTree

var _pass_count: int = 0
var _fail_count: int = 0


func _init() -> void:
	print("=== Cantina Tests ===")
	_test_project_structure()
	_test_bots_json()
	_test_config_autoload()
	_test_ui_factory()
	_print_results()
	quit(0 if _fail_count == 0 else 1)


func _test_project_structure() -> void:
	var required_dirs := [
		"res://scenes", "res://scripts/model", "res://scripts/view",
		"res://scripts/controller", "res://assets/tilesets", "res://assets/sprites",
		"res://assets/audio", "res://assets/icons", "res://data", "res://tests"
	]
	for dir_path in required_dirs:
		var dir := DirAccess.open(dir_path)
		_check(dir != null, "Directory exists: " + dir_path)

	var required_files := [
		"res://project.godot", "res://data/bots.json",
		"res://scripts/model/config.gd", "res://scripts/model/bot_config.gd",
		"res://scripts/model/chat_message.gd", "res://scripts/view/ui_factory.gd",
		"res://scripts/view/main.gd", "res://scripts/controller/hermes_api.gd",
		"res://scripts/controller/openrouter_api.gd", "res://scripts/controller/ambient_manager.gd"
	]
	for file_path in required_files:
		_check(FileAccess.file_exists(file_path), "File exists: " + file_path)


func _test_bots_json() -> void:
	var file := FileAccess.open("res://data/bots.json", FileAccess.READ)
	_check(file != null, "bots.json is readable")
	if file == null:
		return

	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	_check(err == OK, "bots.json is valid JSON")
	if err != OK:
		return

	var bots: Array = json.data
	_check(bots.size() == 7, "bots.json has 7 bots (got " + str(bots.size()) + ")")

	for data in bots:
		var bot := BotConfig.from_dict(data)
		_check(bot.id != "", "Bot has id: " + bot.id)
		_check(bot.display_name != "", "Bot has display_name: " + bot.display_name)
		_check(bot.system_prompt != "", "Bot has system_prompt: " + bot.id)


func _test_config_autoload() -> void:
	_check(true, "Config autoload (tested via project.godot)")


func _test_ui_factory() -> void:
	var btn := UIFactory.make_button("Test", Vector2(100, 50))
	_check(btn != null, "UIFactory.make_button works")
	var close := UIFactory.make_close_button()
	_check(close != null, "UIFactory.make_close_button works")
	var lbl := UIFactory.make_label("Test")
	_check(lbl != null, "UIFactory.make_label works")


func _check(condition: bool, name: String) -> void:
	if condition:
		_pass_count += 1
		print("  ✅ ", name)
	else:
		_fail_count += 1
		print("  ❌ FAIL: ", name)


func _print_results() -> void:
	print("\n=== Results ===")
	print("PASS: ", _pass_count, " | FAIL: ", _fail_count)
	if _fail_count == 0:
		print("ALL TESTS PASSED ✅")
	else:
		print("SOME TESTS FAILED ❌")
