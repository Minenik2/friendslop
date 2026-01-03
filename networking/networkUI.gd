extends CanvasLayer
@onready var noray_component: norayNetworkComponent = NetworkManager.returnNorayComponent()

signal hostPressed()

# code from host to connect
var current_pid : String = ""

func _ready():
	noray_component.createdOID.connect(_on_pid_created)

func _on_host_pressed() -> void:
	AudioManager.playMenuClick()
	
	NetworkManager.start_host()
	%mainMenuALL.hide()
	HudUi.show()
	hostPressed.emit()

func _on_connect_pressed() -> void:
	AudioManager.playMenuClick()
	
	NetworkManager.join_game(%code.text)
	%mainMenuALL.hide()
	
	# a connecting screen will appear once the player is spawned it will hide the screen
	DeathScreen.changeText("Connecting")
	DeathScreen.show()
	HudUi.show()

# show the connect to host menu
func _on_join_pressed() -> void:
	AudioManager.playMenuClick()
	
	%mainmenu.hide()
	%connectToJoin.show()

func _on_pid_created(pid: String):
	current_pid = pid

func _on_copy_pid_pressed() -> void:
	if current_pid.is_empty():
		return
	
	DisplayServer.clipboard_set(current_pid)
	print("Copied PID to clipboard:", current_pid)

# back from connect to host menu
func _on_back_pressed() -> void:
	AudioManager.playMenuClick()
	
	%connectToJoin.hide()
	%mainmenu.show()
