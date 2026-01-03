extends Node3D
class_name HeadBob

# ===============================
# TUNABLE SETTINGS
# ===============================
@export var bob_frequency := 2.5
@export var bob_amplitude := 0.3
@export var bob_smoothing := 4.0

# ===============================
# REFERENCES
# ===============================
@export var camera_pivot : Node3D
@onready var player: playerMain = $".."

# ===============================
# INTERNAL STATE
# ===============================
var bob_time := 0.0
var base_position : Vector3
var initialized := false

# ===============================
# SETUP
# ===============================
func _ready():
	if camera_pivot:
		base_position = camera_pivot.position
		set_physics_process(true)
	else:
		set_physics_process(false)

func _physics_process(delta):
	if player.active_state == playerMain.STATE.WALKING:
		_apply_bob(delta, player.speed, player.speed)
	else:
		_reset_bob(delta)

# ===============================
# INTERNAL
# ===============================
func _apply_bob(delta : float, move_speed : float, max_speed : float):
	bob_time += delta * bob_frequency * (move_speed / max_speed)

	var bob_offset := Vector3(
		0.0,
		sin(bob_time * TAU) * bob_amplitude,
		0.0
	)

	camera_pivot.position = camera_pivot.position.lerp(
		base_position + bob_offset,
		delta * bob_smoothing
	)

func _reset_bob(delta : float):
	bob_time = 0.0
	camera_pivot.position = camera_pivot.position.lerp(
		base_position,
		delta * bob_smoothing
	)
