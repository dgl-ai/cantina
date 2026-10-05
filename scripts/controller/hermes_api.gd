## HermesAPI — HTTP client for Hermes Agent API Server (OpenAI-compatible).
## Docs: https://hermes-agent.nousresearch.com/docs/user-guide/features/api-server
class_name HermesAPI
extends Node

signal response_received(text: String)
signal response_error(error: String)

var _http: HTTPRequest
var _base_url: String = ""
var _api_key: String = ""


func _ready() -> void:
	_http = HTTPRequest.new()
	_http.timeout = 60.0
	add_child(_http)
	_http.request_completed.connect(_on_request_completed)


func configure(base_url: String, api_key: String) -> void:
	_base_url = base_url
	_api_key = api_key


func send_chat(message: String, system_prompt: String = "") -> void:
	if _api_key.is_empty():
		response_error.emit("Hermes API key not configured")
		return

	var messages: Array[Dictionary] = []
	if not system_prompt.is_empty():
		messages.append({"role": "system", "content": system_prompt})
	messages.append({"role": "user", "content": message})

	var body := JSON.stringify({
		"model": "hermes-agent",
		"messages": messages
	})

	var headers := PackedStringArray([
		"Authorization: Bearer " + _api_key,
		"Content-Type: application/json"
	])

	var err := _http.request(_base_url + "/chat/completions", headers, HTTPClient.METHOD_POST, body)
	if err != OK:
		response_error.emit("HTTP request failed: " + str(err))


func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		response_error.emit("Request failed: " + str(result))
		return

	if response_code != 200:
		response_error.emit("API error: " + str(response_code) + " — " + body.get_string_from_utf8())
		return

	var json := JSON.new()
	var err := json.parse(body.get_string_from_utf8())
	if err != OK:
		response_error.emit("JSON parse error")
		return

	var data: Dictionary = json.data
	var choices: Array = data.get("choices", [])
	if choices.is_empty():
		response_error.emit("No response choices")
		return

	var msg: Dictionary = choices[0].get("message", {})
	var text: String = msg.get("content", "")
	response_received.emit(text)
