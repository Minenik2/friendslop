extends CharacterBody3D
class_name enemyMain

@onready var nametag: Label3D = $nametag
@onready var stat_component: statComponent = $StatComponent

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var ground_friction := 20.0
@export var air_friction := 1.0

func _ready() -> void:
	nametag.text = stat_component.characterSheet.character_name
	
func _physics_process(delta: float) -> void:
	if !$changeAuthorityComponent.get_multiplayer_authority():
		return
	# Apply gravity when airborne
	if !is_on_floor():
		velocity.y -= delta * gravity
	
	# Horizontal friction
	var horizontal := Vector3(velocity.x, 0, velocity.z)

	if is_on_floor():
		horizontal = horizontal.move_toward(Vector3.ZERO, ground_friction * delta)
	else:
		horizontal = horizontal.move_toward(Vector3.ZERO, air_friction * delta)

	velocity.x = horizontal.x
	velocity.z = horizontal.z

	move_and_slide()
