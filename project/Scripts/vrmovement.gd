extends CharacterBody3D
@onready var cam = $"XROrigin3D/XRCamera3D"

var SPEED = 2
var JUMP = 0
var xdir = 0
var ydir = 0

func _physics_process(_delta):
	
	var direction = (cam.transform.basis * Vector3(xdir, 0, ydir)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	velocity.y = JUMP
	
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
