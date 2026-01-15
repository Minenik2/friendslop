extends Node3D

var owner_peer_id: int = 0

func _on_hitbox_component_got_hit_by_player(player_hit: playerMain) -> void:
	owner_peer_id = player_hit.name.to_int()
	set_multiplayer_authority(owner_peer_id)
	$"../debugPeer".text = str(owner_peer_id)
