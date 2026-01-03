extends Area3D

@onready var timer: Timer = $Timer
var storedBody

signal respawn(body: playerMain)

func _on_body_entered(body: Node3D) -> void:
	if body.is_multiplayer_authority():
		# todo death effect or something
		AudioManager.playDeath()
		DeathScreen.changeText("Y O U\nF E L L\nO F F")
		DeathScreen.show()
		timer.start()
		storedBody = body


func _on_timer_timeout() -> void:
	respawn.emit(storedBody)
	DeathScreen.hide()
