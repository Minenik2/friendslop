extends Node3D
class_name statComponent

signal characterDied

@export var characterSheet: CharacterStats

func damage(PATK: float, MATK: float):
	characterSheet.current_hp -= roundi(PATK + MATK - characterSheet.defense)
	
	if characterSheet.current_hp <= 0:
		# adding a death component?
		characterDied.emit() 
