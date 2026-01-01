extends CanvasLayer
@onready var network_manager: NetworkManager = %NetworkManager
@onready var noray_component: norayNetworkComponent = $"../NetworkManager/norayComponent"


# code from host to connect
var current_pid : String = ""

func _ready():
	noray_component.createdOID.connect(_on_pid_created)
	%copyPID.disabled = true

func _on_host_pressed() -> void:
	network_manager.start_host()

func _on_join_pressed() -> void:
	network_manager.join_game(%code.text)

func _on_pid_created(pid: String):
	current_pid = pid
	%copyPID.disabled = false

func _on_copy_pid_pressed() -> void:
	if current_pid.is_empty():
		return
	
	DisplayServer.clipboard_set(current_pid)
	print("Copied PID to clipboard:", current_pid)
