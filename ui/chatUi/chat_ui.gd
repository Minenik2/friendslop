extends PanelContainer

@onready var chat_log : RichTextLabel = %chatLog
@onready var message_input : LineEdit = %messageinput

func _ready():
	message_input.text_submitted.connect(_on_text_submitted)
	# join and leave message in chat
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

# ===============================
# SEND MESSAGE
# ===============================

func _on_text_submitted(_text : String):
	_send_message()
	get_viewport().gui_release_focus()
	_toggle_menu()

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
	
	# Auto-scroll to bottom
	await get_tree().process_frame
	chat_log.scroll_to_line(chat_log.get_line_count() - 1)

# ===============================
# Auto join and leave message
# ===============================

func _on_peer_connected(id):
	receive_message(0, "Peer %d joined" % id)

func _on_peer_disconnected(id):
	receive_message(0, "Peer %d left" % id)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("chat"):
		_toggle_menu()
	if event is InputEventMouseButton and event.pressed:
		get_viewport().gui_release_focus()

func _toggle_menu(playAudio: bool = true):
	if playAudio:
		AudioManager.playMenuClick()
	var menu_visible = !$VBoxContainer/inputMenu.visible
	$VBoxContainer/inputMenu.visible = menu_visible
	
	# Control mouse capture
	if menu_visible:
		%messageinput.grab_focus()
		MouseManager.show_mouse()
		UiManager.closeAllUi()
		UiManager.addUi(self)
	else:
		MouseManager.hide_mouse()
		UiManager.closeUi(self)
