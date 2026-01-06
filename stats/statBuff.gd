class_name StatBuff
extends Resource

enum BuffType {
	MULTIPLY,
	ADD
}

@export var stat: CharacterStats.BUFFABLE_STATS
@export var buff_amount: float
@export var buff_type: BuffType

func _init(_stat: CharacterStats.BUFFABLE_STATS = CharacterStats.BUFFABLE_STATS.MAX_HP, 
_buff_amount: float = 1.0, _buff_type: StatBuff.BuffType = BuffType.MULTIPLY) -> void:
	stat = _stat
	buff_type = _buff_type
	buff_amount = _buff_amount

func tooltip() -> String:
	var buffText = ""
	match stat:
		CharacterStats.BUFFABLE_STATS.MAX_HP:
			buffText = "HP"
		CharacterStats.BUFFABLE_STATS.MAX_MP:
			buffText = "MP"
		CharacterStats.BUFFABLE_STATS.DEFENSE:
			buffText = "DEF"
		CharacterStats.BUFFABLE_STATS.PATK:
			buffText = "PATK"
		CharacterStats.BUFFABLE_STATS.MATK:
			buffText = "MATK"
	if buff_type == BuffType.ADD:
		return "Increased %s by +%s" % [buffText, buff_amount]
	else:
		var precentile = buff_amount * 10
		return "Increased %s by %s%" % [buffText, precentile]
