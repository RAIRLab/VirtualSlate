extends CharacterBody3D
@onready var cam = $"XROrigin3D/XRCamera3D"
@onready var main = $"../"

var SPEED = 2
var JUMP = 0
var xdir = 0
var ydir = 0
var rotdir = 0
var ROTATE = 0.025

func _physics_process(_delta):
	
	var direction = (transform.basis * Vector3(xdir, 0, ydir)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	velocity.y = JUMP
	
	if main.moveFlag == false:
		rotate_y(ROTATE*rotdir)
		cam.rotate_y(ROTATE*rotdir)
	
	move_and_slide()


func _on_left_input_vector_2_changed(lname, value):
	if lname ==  "primary":
		xdir = value[0]
		ydir = -value[1]


func _on_left_button_pressed(lname):
	if lname == "by_button":
		JUMP = 2
	if lname == "ax_button":
		JUMP = -2
		

func _on_left_button_released(lname):
	if lname == "by_button":
		JUMP = 0
	if lname == "ax_button":
		JUMP = 0

func _on_right_input_vector_2_changed(rname, value):
	if rname == "primary":
		rotdir = -value[0]
