extends Node3D

@export var sway_amount := 0.02
@export var sway_speed := 2.0
@export var return_speed := 8.0

@onready var sword: MeleeWeapon = $".."

var rest_position : Vector3
var rest_rotation : Vector3

func _ready():
	rest_position = sword.position
	rest_rotation = sword.rotation
	

func _process(delta):
	# Only run on the owning client
	if !is_multiplayer_authority():
		return
	
	var t := Time.get_ticks_msec() * 0.001

	# Idle sway offsets
	var sway_rot_y := sin(t * sway_speed) * sway_amount
	var sway_pos_y := sin(t * sway_speed * 1.5) * sway_amount * 0.5

	# Target transform = rest + sway
	var target_rot := rest_rotation + Vector3(0, sway_rot_y, 0)
	var target_pos := rest_position + Vector3(0, sway_pos_y, 0)

	# Smoothly return after attack animation
	sword.rotation = sword.rotation.lerp(target_rot, return_speed * delta)
	sword.position = sword.position.lerp(target_pos, return_speed * delta)
