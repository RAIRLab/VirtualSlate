extends CharacterBody3D
@onready var head = $Head
@onready var raycast3d = $Head/Camera3D/RayCast3D
@onready var virtual_keyboard_2d = $"../CanvasLayer/VirtualKeyboard2D"
@onready var line_edit = $"../LineEdit"


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.4

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	if virtual_keyboard_2d.visible == false:
		if event is InputEventMouseMotion:
			rotate_y(-deg_to_rad(event.relative.x * MOUSE_SENS))
			head.rotate_x(-deg_to_rad(event.relative.y * MOUSE_SENS))

func _ready():
	line_edit.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	

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
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
