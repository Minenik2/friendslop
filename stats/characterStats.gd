extends Resource
class_name CharacterStats

enum BUFFABLE_STATS {
	MAX_HP,
	MAX_MP,
	DEFENSE, 
	PATK, # physical attack
	MATK # magical attack
}

const STAT_CURVES: Dictionary[BUFFABLE_STATS, Curve] = {
	BUFFABLE_STATS.MAX_HP: preload("uid://cpvv1kbymjjj5"),
	BUFFABLE_STATS.MAX_MP: preload("uid://d047iy7ed81bp"),
	BUFFABLE_STATS.DEFENSE: preload("uid://biqyyq28twgot"),
	BUFFABLE_STATS.PATK: preload("uid://bkbpyv8m171s4"),
	BUFFABLE_STATS.MATK: preload("uid://mslannvmt1gm")
}

signal health_depleted
signal health_changed(current_hp: int, max_hp: int)

@export var character_name: String = "Unnamed"

@export_category("Basic Stats")
@export var level: int = 1

# Baseline stats for resets and scaling
@export var base_max_hp: int = 100
@export var base_max_mp: int = 30
@export var base_patk: float
@export var base_matk: float
@export var base_defense: float
@export var base_speed: float

@export_category("Leveling")
@export var experience: int = 0
@export var experience_to_level: int = 100

# derived stats
var max_hp: int
var current_hp: int: set = _on_health_set
var max_mp: int
var current_mp: int
var patk: float
var matk: float
var defense: float
var speed: float

var is_dead: bool

# buffs
var stat_buffs: Array[StatBuff]

func _init() -> void:
	setupStats.call_deferred()
	
func setupStats():
	# setup current hp and mp at game startup
	current_hp = base_max_hp
	current_mp = base_max_mp

func _on_health_set(new_value: int) -> void:
	current_hp = clampi(new_value,0,max_hp)
	health_changed.emit(current_hp, max_hp)
	if current_hp <= 0:
		health_depleted.emit()

#
# buff
#

func add_buff(buff: StatBuff) -> void:
	stat_buffs.append(buff)
	calculate_derived_stats.call_deferred()
	

func remove_buff(buff: StatBuff) -> void:
	stat_buffs.erase(buff)
	calculate_derived_stats.call_deferred()

#
# Calculate derived stats for scaling
# 

func calculate_derived_stats():
	var stat_multipliers: Dictionary = {} # buff amount to multiply included stats by
	var stat_addends: Dictionary = {} # amount to add to included stats
	for buff in stat_buffs:
		var stat_name: String = BUFFABLE_STATS.keys()[buff.stat].to_lower()
		match buff.buff_type:
			StatBuff.BuffType.ADD:
				if not stat_addends.has(stat_name):
					stat_addends[stat_name] = 0.0
				stat_addends[stat_name] += buff.buff_amount
		
			StatBuff.BuffType.MULTIPLY:
				if not stat_multipliers.has(stat_name):
					stat_multipliers[stat_name] = 1.0
				stat_multipliers[stat_name] += buff.buff_amount
	
	var stat_sample_pos: float = (float(level) / 100.0) - 0.01
	max_hp = roundi(base_max_hp * STAT_CURVES[BUFFABLE_STATS.MAX_HP].sample(stat_sample_pos))
	max_mp = roundi(base_max_mp * STAT_CURVES[BUFFABLE_STATS.MAX_MP].sample(stat_sample_pos))
	patk = round(base_patk * STAT_CURVES[BUFFABLE_STATS.PATK].sample(stat_sample_pos))
	matk = round(base_matk * STAT_CURVES[BUFFABLE_STATS.MATK].sample(stat_sample_pos))
	defense = round(base_defense * STAT_CURVES[BUFFABLE_STATS.DEFENSE].sample(stat_sample_pos))
	
	# apply the buffs
	for stat_name in stat_multipliers:
		var cur_property_name: String = stat_name.to_lower()
		set(cur_property_name, get(cur_property_name) * stat_multipliers[stat_name])
	
	for stat_name in stat_addends:
		var cur_property_name: String = stat_name.to_lower()
		set(cur_property_name, get(cur_property_name) + stat_addends[stat_name])

#
# EXPERIENCE SYSTEM
#

func calculate_exp_to_level() -> int:
	experience_to_level = experience_to_level + 5
	if level % 11 == 0:
		@warning_ignore("integer_division")
		experience_to_level = experience_to_level / 2
	
	return experience_to_level


func gain_exp(amount: int) -> bool:
	experience += amount
	print(character_name, " gained ", amount, " xp. Total ", experience, "/", experience_to_level)
	if experience >= experience_to_level:
		level_up()
		return true
	return false

func level_up():
	level += 1
	# check if the target leveled up naturally or by other means such as using an item
	if experience >= experience_to_level:
		experience =  experience - experience_to_level
	else:
		experience = 0
	experience_to_level = calculate_exp_to_level()
	
	var current_max_hp = max_hp
	var current_max_mp = max_mp
	
	calculate_derived_stats()  # Recalculate everything
	
	# increase health because of level up if not dead
	if not is_dead:
		current_hp += max_hp - current_max_hp
		current_mp += max_mp - current_max_mp
		current_hp = min(current_hp, max_hp)
		current_mp = min(current_mp, max_mp)
	
	# final check to see if the target has xp to level again in case of a huge xp surge
	if experience >= experience_to_level:
		level_up()
