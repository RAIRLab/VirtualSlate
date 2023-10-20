extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const DOUBLETAP_DELAY = 0.25
var doubletap_time = DOUBLETAP_DELAY
var last_keycode = 0
var is_flying = false  # Track the flying state
var fly_speed = 10  # Adjust the flying speed as needed

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D

func _process(delta):
	doubletap_time -= delta

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_SPACE:
			if last_keycode == event.keycode and doubletap_time >= 0:
				toggle_flying()
			last_keycode = event.keycode
			doubletap_time = DOUBLETAP_DELAY
		else:
			last_keycode = 0
		
func toggle_flying():
	is_flying = !is_flying
	if is_flying:
		print("Flying enabled")
		gravity = 0  # Set gravity to 0 or disable it
		# You can also change other properties here, like enabling free movement
	else:
		print("Flying disabled")
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")  # Reset gravity to normal

func _unhandled_input(event: ) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.001)
			camera.rotate_x(-event.relative.y * 0.001)
			camera.rotation.x = clamp(camera.rotation.x,deg_to_rad(-30), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
