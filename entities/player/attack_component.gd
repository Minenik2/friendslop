extends Node3D

@onready var sword: MeleeWeapon = $"../camerapivot/Camera3D/WeaponHolder/sword"
@onready var player: playerMain = $".."
@onready var stat_component: statComponent = $"../statComponent"


func _input(event):
	if event.is_action_pressed("attack") and player.is_multiplayer_authority() and player.active_state != player.STATE.INMENU:
		rpc("rpc_attack")

# multiplayer send it to all peers
@rpc("any_peer", "call_local", "reliable")
func rpc_attack():
	sword.attack()


func _on_sword_area_entered(area: Area3D) -> void:
	if area is hitboxComponent and area != player.get_node("hitboxComponent"):
		var hitbox: hitboxComponent = area
		hitbox.damage(stat_component.characterSheet.patk,stat_component.characterSheet.matk)
		
		var dir := (area.global_position - global_position)
		hitbox.launch(dir, 8.0, 6.0)
		
		print("dealt: %s PATK, %s MATK" % [stat_component.characterSheet.patk, stat_component.characterSheet.matk])
		
		hitbox.playerHitting(player)
		
		if player.is_multiplayer_authority():
			HudUi.get_node("%enemyHealthUI").playerSetup(hitbox.stat_component.characterSheet, hitbox.stat_component.current_hp, hitbox.stat_component.max_hp)
			HudUi.get_node("%enemyHealthUI").show()
