extends PanelContainer

@onready var chat_log : RichTextLabel = %chatLog
@onready var message_input : LineEdit = %messageinput
@onready var send_button : Button = %send

func _ready():
	send_button.pressed.connect(_on_send_pressed)
	message_input.text_submitted.connect(_on_text_submitted)
	# join and leave message in chat
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

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

# call local will be also called on P2P (when client is also host)
@rpc("any_peer", "call_local", "reliable")
func receive_message(sender_id : int, text : String):
	var player_name : String
	var time := Time.get_time_string_from_system()

	if sender_id == 0:
		chat_log.append_text("[color=gray][%s] System: %s[/color]\n" % [time,text])
		return
	elif sender_id == multiplayer.get_unique_id():
		player_name = "You"
	else:
		player_name = "Peer %d" % sender_id

	chat_log.append_text("[%s] %s: %s\n" % [time, player_name, text])

# ===============================
# Auto join and leave message
# ===============================

func _on_peer_connected(id):
	receive_message(0, "Peer %d joined" % id)

func _on_peer_disconnected(id):
	receive_message(0, "Peer %d left" % id)
