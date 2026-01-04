extends CharacterBody3D
class_name playerMain

@export var speed := 5.0
@export var jump_velocity: float = 7
@export var camera: Camera3D

enum STATE {
	IDLE,
	WALKING,
	JUMP,
	FALL,
	INMENU
}

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var pitch: float = 0.0  # Up/down rotation
var player_id: int # for multiplayer

var direction: Vector3

var active_state := STATE.IDLE
	
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
	
	var input_dir = Input.get_vector("left", "right", "up", "down")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	match active_state:
		STATE.IDLE:
			# sliding
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
			if direction != Vector3.ZERO:
				switch_state(STATE.WALKING) # To WALK
			if not is_on_floor():
				switch_state(STATE.FALL) # To FALL
			if Input.is_action_just_pressed("jump"):
				switch_state(STATE.JUMP) # To JUMP
		STATE.WALKING:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			if direction == Vector3.ZERO:
				switch_state(STATE.IDLE) # To IDLE 
			if not is_on_floor():
				switch_state(STATE.FALL) # To FALL
			if Input.is_action_just_pressed("jump"):
				switch_state(STATE.JUMP) # To JUMP
		STATE.JUMP:
			velocity.y = jump_velocity
			switch_state(STATE.FALL)
		STATE.FALL:
			velocity.y -= gravity * delta
			if direction != Vector3.ZERO:
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed
			
			if is_on_floor():
				switch_state(STATE.IDLE) # To IDLE 
		STATE.INMENU:
			velocity.y -= gravity * delta
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
			if UiManager.uiArray.is_empty():
				switch_state(STATE.IDLE)
	
	# at any point if player opens menu, change to inmenu state
	if !UiManager.uiArray.is_empty():
		switch_state(STATE.INMENU)
	
	move_and_slide()

func switch_state(to_state: STATE) -> void:
	active_state = to_state
	
	match active_state:
		STATE.IDLE:
			pass
		STATE.JUMP:
			pass
		STATE.WALKING:
			pass
		STATE.FALL:
			pass
