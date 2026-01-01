extends PanelContainer

@onready var chat_log : RichTextLabel = %chatLog
@onready var message_input : LineEdit = %messageinput
@onready var send_button : Button = %send

func _ready():
	send_button.pressed.connect(_on_send_pressed)
	message_input.text_submitted.connect(_on_text_submitted)

# ===============================
# SEND MESSAGE
# ===============================

func _on_send_pressed():
	_send_message()

func _on_text_submitted(_text : String):
	_send_message()

func _send_message():
	var text := message_input.text.strip_edges()
	if text.is_empty():
		return

	message_input.clear()

	# Send to everyone (including yourself)
	rpc("receive_message", multiplayer.get_unique_id(), text)

# ===============================
# RECEIVE MESSAGE (RPC)
# ===============================

@rpc("any_peer", "reliable")
func receive_message(sender_id : int, text : String):
	var playerName := "You" if sender_id == multiplayer.get_unique_id() else "Peer %d" % sender_id
	chat_log.append_text("%s: %s\n" % [playerName, text])
