extends Node3D

#@onready var line_edit = $"../LineEdit"
#@onready var virtual_keyboard_2d = $"../CanvasLayer/VirtualKeyboard2D"
@onready var ray = $"CharacterBody3D/XROrigin3D/Right/rHand/RayCast3D"
@onready var rightHand = $"CharacterBody3D/XROrigin3D/Right"
@onready var head = $"../"
@onready var pointerPG = head.pg
@onready var keyboard = $"CharacterBody3D/XROrigin3D/Left/Keyboard"
@onready var nodeRay = $"CharacterBody3D/XROrigin3D/Right/rHand/RayCast3D"
@onready var keyRay = $"CharacterBody3D/XROrigin3D/Right/rHand/keyRay"
@onready var lineEdit = $"CharacterBody3D/XROrigin3D/Left/Keyboard/Text/".get_child(0).get_child(0).get_child(0)

#Movement variables
var SPEED = 1.0
var JUMP_VELOCITY = 1.0
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
var newMeshOffset = 10
const offsetMax = 50
const offsetMin = 10

#Move node vars
var distanceToNode
var blockPOS
var offsetPosition
var changeDistance = 0
@export var moveFlag = false
var rotdir = 0

#Input variables
@export var inputFlag = false

func rayTraceSelect():
	if selectionCount >= selectGate:
		return	

	var nodeSelect = ray.get_collider()
	if nodeSelect != null:
		if nodeSelect.get_parent().get_class() == "LogNode":
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
	inputFlag = false
	
func newNodeLocationMesh():
	var lookDirection = rightHand.get_global_transform().basis.z
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
	tempMesh.global_scale(Vector3(1.0,.5,.2))
	tempMesh.global_position = rightHand.global_position - 5*lookDirection
	newMeshExists = true
	newMeshPointer = tempMesh

func clearNewNodeLocationMesh():
	newMeshPointer.queue_free()
	newMeshExists = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$"CharacterBody3D/XROrigin3D/Left/lHand/ModeText".mesh.text = modeTypes.keys()[playerMode]
	keyboard.hide()
	keyRay.enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	

	match playerMode:
		modeTypes.CONNECT:
			pass
		modeTypes.DELETE_NODE:
			pass
		modeTypes.CREATE_NODE:
			if newMeshExists == false:
				newNodeLocationMesh()
			newMeshOffset += changeDistance*.2
			var lookDirection = rightHand.get_global_transform().basis.z
			offsetPosition = rightHand.global_position - newMeshOffset*lookDirection
			newMeshPointer.global_position = offsetPosition
		modeTypes.MOVE_NODE:
			var lookDirection = rightHand.get_global_transform().basis.z
			if selectionCount == 1:
				distanceToNode+= changeDistance*.2
				offsetPosition = rightHand.global_position - (distanceToNode)*lookDirection
				selectArray[0].global_position = offsetPosition
				pointerPG.updateEdges(selectArray[0])
				selectArray[0].rotate_y(rotdir*TURN_SPEED)
		modeTypes.INPUT_DATA:
			if inputFlag == true:
				keyboard.show()
				nodeRay.hide()
				keyRay.enabled = true
				if Input.is_action_just_pressed("EnterInput"):
					selectArray[0].setData(lineEdit.text)
					unselectAll()
					lineEdit.clear()
					inputFlag = false
			else:
				keyboard.hide()
				nodeRay.show()
				keyRay.enabled = false

func _on_right_button_pressed(rname):
	if rname == "trigger_click" and inputFlag == false:
		rayTraceSelect()
		match playerMode:
			modeTypes.CONNECT:
				pass
			modeTypes.DELETE_NODE:
				pass
			modeTypes.CREATE_NODE:
				pass
			modeTypes.MOVE_NODE:
				if selectionCount == 1:
					blockPOS = selectArray[0].global_position
					distanceToNode = (blockPOS - rightHand.global_position).length()
					moveFlag = true
				else: 
					moveFlag = false
			modeTypes.INPUT_DATA:
				if selectionCount == 1:
					inputFlag = true
			modeTypes.DELETE_EDGE:
				pass
		
	if rname == "by_button":
		unselectAll()
		
	if rname == "ax_button":
		match playerMode:
			modeTypes.CONNECT:
				if selectionCount == 2:
					pointerPG.addEdge(selectArray[0], selectArray[1])
					unselectAll()
			modeTypes.DELETE_NODE:
				if selectionCount == 1:
					pointerPG.removeNode(selectArray[0])
					unselectAll()
			modeTypes.CREATE_NODE:
				clearNewNodeLocationMesh()
				head = get_node("/root/main")
				pointerPG = head.pg
				pointerPG.addNode(offsetPosition)
			modeTypes.MOVE_NODE:
				unselectAll()
			modeTypes.INPUT_DATA:
				pass
			modeTypes.DELETE_EDGE:
				if selectionCount == 2:
					if selectArray[1].isChild(selectArray[0]):
						pointerPG.removeEdge(selectArray[1], selectArray[0])
					else:
						pointerPG.removeEdge(selectArray[0], selectArray[1])
					unselectAll()
		

func _on_left_button_pressed(lname):
	if lname == "trigger_click" and inputFlag == false:
		inputFlag = false
		moveFlag = false
		if playerMode < 5:
			playerMode = playerMode+1
		else:
			playerMode = modeTypes.CREATE_NODE
			
		match playerMode:
			modeTypes.CREATE_NODE:
				selectGate = 0
			modeTypes.INPUT_DATA:
				selectGate = 2
				clearNewNodeLocationMesh()
			modeTypes.CONNECT: 
				selectGate = 3
			modeTypes.DELETE_EDGE:
				selectGate = 3
			modeTypes.DELETE_NODE:
				selectGate = 2
			modeTypes.MOVE_NODE:
				selectGate = 2
		$"CharacterBody3D/XROrigin3D/Left/lHand/ModeText".mesh.text = modeTypes.keys()[playerMode]
		unselectAll()
	
func _on_right_input_vector_2_changed(rjname, value):
	if rjname == "primary" and inputFlag == false:
		match playerMode:
			modeTypes.CONNECT:
				pass
			modeTypes.DELETE_NODE:
				pass
			modeTypes.CREATE_NODE:
				changeDistance = value[1]
			modeTypes.MOVE_NODE:
				if selectionCount == 1:
					changeDistance = value[1]
					rotdir = -value[0]
			modeTypes.INPUT_DATA:
				pass
		
