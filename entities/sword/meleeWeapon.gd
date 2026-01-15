extends Node3D
class_name MeleeWeapon

@export var damage := 20
@export var attack_cooldown := 1.0

var can_attack := true

@onready var anim := $AnimationPlayer
@onready var idle_sway_component: Node3D = $idleSwayComponent

func attack():
	if !can_attack:
		return

	can_attack = false
	anim.play("attack")

	await anim.animation_finished
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
