extends CanvasLayer
@onready var network_manager: NetworkManager = $"../NetworkManager"


func _on_host_pressed() -> void:
	network_manager.host_game()


func _on_join_pressed() -> void:
	network_manager.join_game("7777")
