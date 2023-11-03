extends CharacterBody3D
@onready var line_edit = $"../LineEdit"
@onready var virtual_keyboard_2d = $"../CanvasLayer/VirtualKeyboard2D"
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var head = get_node("/root/main")
@onready var pointerPG = head.pg

#Movement variables
var SPEED = 15.0
var JUMP_VELOCITY = 15.0
const TURN_SPEED = 0.03


#Selection variables
@export var selectionCount = 0
@export var selectArray: Array[LogNode]
const RAY_LENGTH = 1000

#Mode variables
enum modeTypes {CREATE_NODE, INPUT_DATA, CONNECT, DELETE_EDGE, DELETE_NODE, MOVE_NODE}
var playerMode = modeTypes.MOVE_NODE
var selectGate = 2

#Colors
const regularColor = Color(0.5, 0.75, 0.75, 0.25)
const selectColor = Color(0.75, 0.75, 0.5, 0.25)
const newColor = Color(0.25, 0.25, 0.25, 0.75)

#Create Node flags
var newMeshExists = false
var newMeshPointer
var newMeshOffset = 15
const offsetMax = 50
const offsetMin = 10

#Move node vars
var distanceToNode

#Input variables
var inputFlag = false

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
	
func newNodeLocationMesh():
	var cam = $Neck/Camera3D
	var lookDirection = cam.get_global_transform().basis.z
	head = get_node("/root/main")
	var tempMesh = MeshInstance3D.new()
	tempMesh.set_name("tempMesh")
	head.add_child(tempMesh)
	var box = BoxMesh.new()
	tempMesh.mesh = box
	var skin = StandardMaterial3D.new()
	tempMesh.set_surface_override_material(0,skin)
	skin.albedo_color = newColor
	skin.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	tempMesh.global_scale(Vector3(10,5,2))
	tempMesh.global_position = cam.global_position - 10*lookDirection
	newMeshExists = true
	newMeshPointer = tempMesh
	
func clearNewNodeLocationMesh():
	newMeshPointer.queue_free()
	newMeshExists = false
	
func _unhandled_input(event: ) -> void:
	if event is InputEventMouseButton:
		if virtual_keyboard_2d.visible == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.001)
			camera.rotate_x(-event.relative.y * 0.001)
			camera.rotation.x = clamp(camera.rotation.x,deg_to_rad(-45), deg_to_rad(60))

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	line_edit.hide()
	$Neck/Camera3D/Mode/Label.text = modeTypes.keys()[playerMode]

func _physics_process(_delta):

	#disallow all node selection/movement inputs when inputing data
	if inputFlag == false:
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
		var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
		var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		move_and_slide()
	
		# Changing modes (maybe replace with radial wheel)	
		if Input.is_action_just_pressed("Change_Mode"):
			if playerMode < 5:
				playerMode = playerMode+1
			else:
				playerMode = 0
				
			match playerMode:
				modeTypes.CREATE_NODE:
					selectGate = 0
				modeTypes.INPUT_DATA:
					selectGate = 2
					clearNewNodeLocationMesh();
				modeTypes.CONNECT: 
					selectGate = 3
				modeTypes.DELETE_EDGE:
					selectGate = 3
				modeTypes.DELETE_NODE:
					selectGate = 2
				modeTypes.MOVE_NODE:
					selectGate = 2
			$Neck/Camera3D/Mode/Label.text = modeTypes.keys()[playerMode]
			unselectAll()
			
		# Selecting nodes
		if Input.is_action_just_pressed("Interact"):
			rayTraceSelect()
			
		if Input.is_action_pressed("Sprint"):
			SPEED = 30
			JUMP_VELOCITY = 30
		
		if Input.is_action_just_released("Sprint"):
			SPEED = 15
			JUMP_VELOCITY = 15
			
		
		
	# Mode based actions on nodes
	match playerMode:
		modeTypes.DELETE_EDGE:
			if Input.is_action_just_pressed("Confirm"):
				if selectionCount == 2:
					if selectArray[1].isChild(selectArray[0]):
						pointerPG.removeEdge(selectArray[1], selectArray[0])
					else:
						pointerPG.removeEdge(selectArray[0], selectArray[1])
					unselectAll()
		modeTypes.CONNECT:
			if Input.is_action_just_pressed("Confirm"):
				if selectionCount == 2:
					pointerPG.addEdge(selectArray[0], selectArray[1])
					unselectAll()
		modeTypes.DELETE_NODE:
			if Input.is_action_just_pressed("Confirm"):
				if selectionCount == 1:
					pointerPG.removeNode(selectArray[0])
					unselectAll()
		modeTypes.CREATE_NODE:
			if newMeshExists == false:
				newNodeLocationMesh()
			var cam = $Neck/Camera3D
			var lookDirection = cam.get_global_transform().basis.z
			var offsetPosition = cam.global_position - newMeshOffset*lookDirection
			newMeshPointer.global_position = offsetPosition
			
			if Input.is_action_just_pressed("offsetPlus"):
				if newMeshOffset < offsetMax:
					newMeshOffset += 1
			if Input.is_action_just_pressed("offsetMinus"):
				if newMeshOffset > offsetMin:
					newMeshOffset -= 1
			if Input.is_action_just_pressed("Confirm"):
				clearNewNodeLocationMesh()
				head = get_node("/root/main")
				pointerPG = head.pg
				pointerPG.addNode(offsetPosition)
		modeTypes.MOVE_NODE:
			var cam = $Neck/Camera3D
			var lookDirection = cam.get_global_transform().basis.z
			if Input.is_action_just_pressed("Interact") and inputFlag == false:
				if selectionCount != 0:
					var blockPOS = selectArray[0].global_position
					distanceToNode = (blockPOS - cam.global_position).length()
			if selectionCount == 1:
				var offsetPosition = cam.global_position - distanceToNode*lookDirection
				selectArray[0].global_position = offsetPosition
				if Input.is_action_just_pressed("offsetPlus"):
					if distanceToNode < offsetMax:
						distanceToNode += 1
				if Input.is_action_just_pressed("offsetMinus"):
					if distanceToNode > offsetMin:
						distanceToNode -= 1
				if Input.is_action_pressed("RotateLeft") and inputFlag == false:
					selectArray[0].rotate_y(-TURN_SPEED)
				if Input.is_action_pressed("RotateRight") and inputFlag == false:
					selectArray[0].rotate_y(TURN_SPEED)
				pointerPG.updateEdges(selectArray[0])
		modeTypes.INPUT_DATA:
			if selectionCount == 1:
				inputFlag = true
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
				virtual_keyboard_2d.show()
				line_edit.show()
				#line_edit.grab_focus()
			if Input.is_action_just_pressed("EnterInput") and inputFlag == true:
				selectArray[0].setData(line_edit.text)
				line_edit.clear()
				line_edit.hide()
				virtual_keyboard_2d.hide()
				inputFlag = false
				print(selectArray[0].getData())
				unselectAll()
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

