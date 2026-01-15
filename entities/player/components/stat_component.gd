extends Node3D
class_name statComponent

signal characterDied

@export var characterSheet: CharacterStats
var current_hp = 2
var max_hp = 2

func _ready() -> void:
	characterSheet = characterSheet.duplicate()
	characterSheet.calculate_derived_stats()
	current_hp = characterSheet.current_hp
	max_hp = characterSheet.max_hp

func damage(PATK: float, MATK: float):
	if !is_multiplayer_authority():
		return
	characterSheet.current_hp -= max(roundi(PATK + MATK - characterSheet.defense),  roundi((PATK + MATK) * 0.1))
	
	print("current hp: ",  characterSheet.current_hp, characterSheet.is_dead)
	current_hp = characterSheet.current_hp
	max_hp = characterSheet.max_hp
	
	if characterSheet.current_hp <= 0:
		if !characterSheet.is_dead:
			characterSheet.is_dead = true
			characterDied.emit() 

func respawn():
	characterSheet.current_hp = characterSheet.max_hp
	characterSheet.is_dead = false
