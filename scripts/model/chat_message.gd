## ChatMessage — Data class for a chat message in the cantina.
class_name ChatMessage
extends Resource

enum Sender { PLAYER, BOT }

@export var sender: Sender = Sender.PLAYER
@export var sender_name: String = ""
@export var text: String = ""
@export var timestamp: int = 0


static func create_player(text: String, name: String = "David") -> ChatMessage:
	var msg := ChatMessage.new()
	msg.sender = Sender.PLAYER
	msg.sender_name = name
	msg.text = text
	msg.timestamp = Time.get_unix_time_from_system()
	return msg


static func create_bot(text: String, name: String) -> ChatMessage:
	var msg := ChatMessage.new()
	msg.sender = Sender.BOT
	msg.sender_name = name
	msg.text = text
	msg.timestamp = Time.get_unix_time_from_system()
	return msg
