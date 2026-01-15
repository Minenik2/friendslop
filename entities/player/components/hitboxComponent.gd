extends Area3D
class_name hitboxComponent

@export var stat_component: statComponent
@export var launch_component: launchComponent

signal gotHitByPlayer(player_hit: playerMain)

func damage(pATK: float, mATK: float):
	if stat_component:
		stat_component.damage(pATK, mATK)

func launch(direction: Vector3, force: float, upward_force: float = 0.0):
	if launch_component:
		launch_component.launch(direction, force, upward_force)

# when hit the current player will give the data that it hit the object
func playerHitting(player: playerMain):
	gotHitByPlayer.emit(player)
