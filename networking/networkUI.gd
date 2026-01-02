extends CanvasLayer
@onready var noray_component: norayNetworkComponent = NetworkManager.returnNorayComponent()


# code from host to connect
var current_pid : String = ""

func _ready():
	noray_component.createdOID.connect(_on_pid_created)
	%copyPID.disabled = true

func _on_host_pressed() -> void:
	NetworkManager.start_host()
	%mainMenuALL.hide()
	%copyPID.show()
	HudUi.show()

func _on_connect_pressed() -> void:
	NetworkManager.join_game(%code.text)
	%mainMenuALL.hide()
	HudUi.show()

# show the connect to host menu
func _on_join_pressed() -> void:
	%mainmenu.hide()
	%connectToJoin.show()

func _on_pid_created(pid: String):
	current_pid = pid
	%copyPID.disabled = false

func _on_copy_pid_pressed() -> void:
	if current_pid.is_empty():
		return
	
	DisplayServer.clipboard_set(current_pid)
	print("Copied PID to clipboard:", current_pid)

# back from connect to host menu
func _on_back_pressed() -> void:
	%connectToJoin.hide()
	%mainmenu.show()
