extends Node3D
class_name playerDeathComponent

@onready var respawn_timer: Timer = $Timer
@onready var player: playerMain = $".."

func _on_stat_component_character_died() -> void:
	if !player.is_multiplayer_authority():
		return
	# todo death effect or something
	AudioManager.playDeath()
	DeathScreen.changeText("Y O U\nD I E D")
	DeathScreen.show()
	respawn_timer.start()

func _on_timer_timeout() -> void:
	SignalBus.playerRespawn.emit(player)
	DeathScreen.hide()
	$"../statComponent".respawn()
