extends Node

@export var stat_component: statComponent

func damage(pATK: float, mATK: float):
	if stat_component:
		stat_component.damage(pATK, mATK)
