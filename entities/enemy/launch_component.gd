extends Node3D
class_name launchComponent

@export var owner_body: CharacterBody3D

func launch(direction: Vector3, force: float, upward_force: float = 0.0):
	if !owner_body:
		return
	
	if owner_body is playerMain:
		owner_body.active_state = playerMain.STATE.KNOCKED
		$endKnockupState.start()

	var dir := direction.normalized()
	
	print(dir)
	
	# Horizontal knockback (always)
	owner_body.velocity.x += dir.x * force
	owner_body.velocity.z += dir.z * force

	# --- Grounded correction ---
	var is_grounded := owner_body.has_method("is_on_floor") and owner_body.is_on_floor()

	if is_grounded:
		# If hit from above or shallow angle → force a hop
		var hop_force: float = max(upward_force, force * 0.6)
		owner_body.velocity.y = hop_force
	else:
		# Airborne → normal vertical launch
		if upward_force > 0.0:
			owner_body.velocity.y = max(owner_body.velocity.y, upward_force)


func _on_timer_timeout() -> void:
	owner_body.active_state = playerMain.STATE.IDLE
