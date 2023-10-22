extends CharacterBody3D
@onready var line_edit = $"../LineEdit"
@onready var virtual_keyboard_2d = $"../CanvasLayer/VirtualKeyboard2D"


const SPEED = 5.0
const JUMP_VELOCITY = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D

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

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	line_edit.hide()

func _physics_process(delta):
	if Input.is_action_just_pressed("Keyboard"):
		if virtual_keyboard_2d.visible == false:
			virtual_keyboard_2d.show()
			line_edit.show()
			line_edit.grab_focus()
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)            
	if Input.is_action_just_pressed("Enter"):
		virtual_keyboard_2d.hide()
		line_edit.hide()
		print(line_edit.text)
		line_edit.clear()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Handle Jump.
	if Input.is_action_pressed("Up"):
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("Up"):
		velocity.y = 0
	if Input.is_action_pressed("Down"):
		velocity.y = -JUMP_VELOCITY
	if Input.is_action_just_released("Down"):
		velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if virtual_keyboard_2d.visible == false:
		var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
		var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
