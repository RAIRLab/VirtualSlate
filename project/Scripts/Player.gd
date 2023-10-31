extends CharacterBody3D
@onready var line_edit = $"../LineEdit"
@onready var virtual_keyboard_2d = $"../CanvasLayer/VirtualKeyboard2D"

#Movement variables
const SPEED = 10.0
const JUMP_VELOCITY = 10

#Selection variables
var selectionCount = 0
var selectArray: Array[LogNode]
const RAY_LENGTH = 1000

#Mode variables
enum modeTypes {CREATE_NODE, INPUT_DATA, CONNECT, DELETE_EDGE, DELETE_NODE}
var playerMode = modeTypes.CREATE_NODE
var selectGate = 0

#Colors
const regularColor = Color(0.5, 0.75, 0.75, 0.25)
const selectColor = Color(0.75, 0.75, 0.5, 0.25)
const newColor = Color(0.75, 0.75, 0.75, 0.05)

var head
var pointerPG

func rayTraceSelect():
	if selectionCount >= selectGate:
		return
	
	var space_state = get_world_3d().direct_space_state
	var cam = $Neck/Camera3D
	var mousepos = get_viewport().get_mouse_position()
				
	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	query.exclude = [self]
				
	var results = space_state.intersect_ray(query)
	var nodeSelect = results.get("collider")
	if nodeSelect != null:
		var pNode = nodeSelect.get_parent()
		if selectArray.find(pNode) != -1:
			selectArray.erase(pNode)
			selectionCount -= 1
			pNode.get_child(0).get_material_override().albedo_color = regularColor
		else:
			if selectionCount < selectGate-1:
				selectArray.append(pNode)
				selectionCount += 1
				pNode.get_child(0).get_material_override().albedo_color = selectColor
		
func unselectAll():
	for pNode in selectArray:
		pNode.get_child(0).get_material_override().albedo_color = regularColor
	selectArray.clear()
	selectionCount = 0
	
		

# Get the gravity from the project settings to be synced with RigidBody nodes.
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
	$Neck/Camera3D/Mode/Label.text = modeTypes.keys()[playerMode]


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
		
	# Vertical Movement
	if Input.is_action_pressed("Up"):
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("Up"):
		velocity.y = 0
	if Input.is_action_pressed("Down"):
		velocity.y = -JUMP_VELOCITY
	if Input.is_action_just_released("Down"):
		velocity.y = 0

	# X-Y axis movement
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
	
	# Changing modes	
	if Input.is_action_just_pressed("Change_Mode"):
		if playerMode < 4:
			playerMode = playerMode+1
		else:
			playerMode = 0
			
		match playerMode:
			modeTypes.CREATE_NODE:
				selectGate = 0
			modeTypes.INPUT_DATA:
				selectGate = 2
			modeTypes.CONNECT: 
				selectGate = 3
			modeTypes.DELETE_EDGE:
				selectGate = 3
			modeTypes.DELETE_NODE:
				selectGate = 2
		$Neck/Camera3D/Mode/Label.text = modeTypes.keys()[playerMode]
		unselectAll()
			
	# Selecting nodes
	if Input.is_action_just_pressed("Interact"):
		rayTraceSelect()
		
	# Mode based actions on nodes
	match playerMode:
		modeTypes.DELETE_EDGE:
			if Input.is_action_just_pressed("Confirm"):
				if selectionCount == 2:
					head = get_node("/root/main")
					pointerPG = head.pg
					if selectArray[1].isChild(selectArray[0]):
						pointerPG.removeEdge(selectArray[1], selectArray[0])
					else:
						pointerPG.removeEdge(selectArray[0], selectArray[1])
					unselectAll()
		modeTypes.CONNECT:
			if Input.is_action_just_pressed("Confirm"):
				if selectionCount == 2:
					head = get_node("/root/main")
					pointerPG = head.pg
					pointerPG.addEdge(selectArray[0], selectArray[1])
					unselectAll()
		modeTypes.DELETE_NODE:
			if Input.is_action_just_pressed("Confirm"):
				if selectionCount == 1:
					head = get_node("/root/main")
					pointerPG = head.pg
					pointerPG.removeNode(selectArray[0])
					unselectAll()
				
