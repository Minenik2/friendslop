extends Node3D
class_name playerDeathComponent

@onready var respawn_timer: Timer = $Timer

signal respawn

func _on_stat_component_character_died() -> void:
	# todo death effect or something
	AudioManager.playDeath()
	DeathScreen.changeText("Y O U\nD I E D")
	DeathScreen.show()
	respawn_timer.start()

func _on_timer_timeout() -> void:
	respawn.emit()
	DeathScreen.hide()
