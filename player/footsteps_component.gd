extends Node3D
@onready var player: playerMain = $".."

# audio for footsteps
var step_timer := 0.0
var step_interval := 0.4  # Time between step sounds, adjust as needed

# landing detection
var was_on_floor: bool = false
var landed_enabled := false

func _ready():
	await get_tree().create_timer(0.1).timeout
	landed_enabled = true

func _physics_process(delta):
	step_timer -= delta # step sound
	
	if player.direction != Vector3.ZERO and step_timer <= 0.0 and player.active_state == playerMain.STATE.WALKING and !$land.playing:
		#$footsteps.play()
		rpc("rpc_play_footstep") # share to other clients
		step_timer = step_interval
	
	# Landing sound check
	if landed_enabled and player.is_on_floor() and not was_on_floor and player.velocity.y <= 0:
		#$land.play()
		rpc("rpc_play_land")

	# Update last floor state
	was_on_floor = player.is_on_floor()

@rpc("any_peer", "call_local", "unreliable")
func rpc_play_footstep():
	#if $footsteps.playing:
	#	return
	$footsteps.play()

@rpc("any_peer", "call_local", "unreliable")
func rpc_play_land():
	$land.play()
