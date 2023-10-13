extends Node
func initializeProofGraph():
	var pg = ProofGraph.new()
	pg.set_name("ProofGraph")
	self.add_child(pg)
	return pg
	
func addNewLogNode(position: Vector3, data: int, pgInstance: ProofGraph):
	#Creates a new LogNode, adds it to the nodeMap, sets the values
	var newNode = LogNode.new()
	newNode.setNode(pgInstance.getNodeCount(), position, data)
	pgInstance.addNode(newNode)
	
	#adds the lognode to the godot scene tree and sets global position
	newNode.set_name(str(newNode.getID()))
	newNode.global_position = newNode.getPosition()
	$ProofGraph.add_child(newNode)
	
	#creates a box mesh for the lognode
	var newMesh = MeshInstance3D.new()
	newNode.add_child(newMesh)
	newMesh.mesh = BoxMesh.new()
	newMesh.global_scale(Vector3(10,4,4))
	newMesh.mesh.material = StandardMaterial3D.new()
	newMesh.mesh.material.flags_transparent = true
	newMesh.mesh.material.albedo_color = Color(0.5, 0.75, 0.75, 0.25)
	
	#create a textmesh for the lognode
	var textM = MeshInstance3D.new()
	newNode.add_child(textM)
	textM.mesh = TextMesh.new()
	textM.mesh.set_text(str(newNode.getData()))
	textM.global_scale(Vector3(15,15,15))
	
	
func createGraphicEdge(start: Vector3, end: Vector3):
	
	#the line part
	var linemesh = MeshInstance3D.new()
	linemesh.mesh = CylinderMesh.new()
	linemesh.mesh.material = ORMMaterial3D.new()
	linemesh.mesh.material.albedo_color = Color(0.17, 0.42, 0.89 )
	
	var boxOffset = Vector3(0,2,0)
	
	var startOffset
	var endOffset
	
	if start.y > end.y:
		startOffset = start - boxOffset
		endOffset = end + boxOffset
	else:
		startOffset = start + boxOffset
		endOffset = end - boxOffset
	
	var position = (start+end)/2
	var length = (endOffset-startOffset).length()
	
	linemesh.global_position = position
	linemesh.global_scale(Vector3(0.2, 0.2, length))
	linemesh.look_at_from_position(position, endOffset, Vector3.LEFT)
	
	self.add_child(linemesh)
	
	
func addNewEdge(parent: String, child: String, pgInstance: ProofGraph):
	var pID = get_node("ProofGraph/"+parent)
	var cID = get_node("ProofGraph/"+child)
	
	pgInstance.addEdge(pID.getID(), cID.getID())
	createGraphicEdge(pID.getPosition(), cID.getPosition())
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var pgInstance = initializeProofGraph()
	addNewLogNode(Vector3(0,-2,0), 45, pgInstance)
	addNewLogNode(Vector3(8,6,0), 125, pgInstance)
	addNewLogNode(Vector3(-8,6,0), 68, pgInstance)
	addNewLogNode(Vector3(8,14,0), 135, pgInstance)

	
	addNewEdge("0", "1", pgInstance)
	addNewEdge("0", "2", pgInstance)
	addNewEdge("1", "3", pgInstance)
	
	print(pgInstance.getData(0))
	print(pgInstance.getData(1))
	print(pgInstance.getData(2))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
