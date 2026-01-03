extends CharacterBody3D

@export var speed := 5.0
@export var jump_velocity: float = 7
@export var camera: Camera3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var pitch: float = 0.0  # Up/down rotation
var player_id: int # for multiplayer
	
func _enter_tree() -> void:
	
	set_multiplayer_authority(name.to_int())
	
	# Only the owning peer controls input + camera
	if not is_multiplayer_authority():
		camera.current = false
		set_process(false)
		set_physics_process(false)
		set_process_input(false)
	else:
		DeathScreen.hide()
		camera.current = true
		MouseManager.try_hide_mouse()

func _unhandled_input(event):
	# Mouse look (only when captured)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * GameSettingManager.mouse_sensitivity)
		pitch = clamp(pitch - event.relative.y * GameSettingManager.mouse_sensitivity, -PI/2, PI/2)
		camera.rotation.x = pitch

func _physics_process(delta):
	if not is_multiplayer_authority():
		return
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity


	self.velocity = velocity
	move_and_slide()
