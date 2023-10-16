extends Node
func initializeProofGraph():
	var pg = ProofGraph.new()
	pg.set_name("ProofGraph")
	self.add_child(pg)
	return pg
	
func addNewLogNode(position: Vector3, pgInstance: ProofGraph):
	#Creates a new LogNode, adds it to the nodeMap, sets the values
	var newNode = LogNode.new()
	newNode.setNode(pgInstance.getNodeCount(), position)
	pgInstance.addNode(newNode)
	
	#adds the lognode to the godot scene tree and sets global position
	newNode.set_name(str(newNode.getID()))
	newNode.global_position = newNode.getPosition()
	$ProofGraph.add_child(newNode)
	
	#creates a box mesh for the lognode
	var newMesh = MeshInstance3D.new()
	newNode.add_child(newMesh)
	newMesh.set_name("Box"+str(newNode.getID()))
	newMesh.mesh = BoxMesh.new()
	newMesh.global_scale(Vector3(10,5,2))
	newMesh.mesh.material = StandardMaterial3D.new()
	newMesh.mesh.material.flags_transparent = true
	newMesh.mesh.material.albedo_color = Color(0.5, 0.75, 0.75, 0.25)
	
	#create a textmesh for ID for the lognode
	var idM = MeshInstance3D.new()
	newNode.add_child(idM)
	idM.set_name("ID"+str(newNode.getID()))
	idM.position = Vector3(-3,1.45,0)
	idM.mesh = TextMesh.new()
	idM.mesh.material = StandardMaterial3D.new()
	idM.mesh.set_text("ID: "+str(newNode.getID()))
	idM.global_scale(Vector3(8,8,5))
	
	
func addDataToNode(nodeID: int, newData: String):
	
	#create a textmesh for data for the lognode
	var workingNode = get_node("ProofGraph/"+str(nodeID))
	workingNode.addData(newData)
	var textM = MeshInstance3D.new()
	var oldText = get_node("ProofGraph/"+str(nodeID)+"/Data"+str(nodeID))
	workingNode.remove_child(oldText)
	workingNode.add_child(textM)
	textM.set_name("Data"+str(workingNode.getID()))
	textM.mesh = TextMesh.new()
	textM.mesh.set_text(str(workingNode.getData()))
	textM.global_scale(Vector3(13,13,5))
	textM.mesh.material = StandardMaterial3D.new()
	textM.mesh.material.emission_enabled = true
	textM.mesh.material.emission = Color(.8,.8,.9,.6)
	textM.mesh.material.emission_energy_multiplier = 5.0
	
	
func createGraphicEdge(start: Vector3, end: Vector3, startID: int, endID: int):
	
	#the line part
	var linemesh = MeshInstance3D.new()
	linemesh.mesh = CylinderMesh.new()
	linemesh.mesh.material = ORMMaterial3D.new()
	linemesh.mesh.material.albedo_color = Color(0.17, 0.42, 0.89 )
	linemesh.set_name(str(startID)+str(endID))
	
	var boxOffset = Vector3(0,2.5,0)
	
	var startOffset
	var endOffset
	
	if start.y > end.y:
		startOffset = start - boxOffset
		endOffset = end + boxOffset
	else:
		startOffset = start + boxOffset
		endOffset = end - boxOffset
		
	var workingNode = get_node("ProofGraph/"+str(startID))
	workingNode.add_child(linemesh)
	
	var location = (start+end)/2
	var length = (endOffset-startOffset).length()
	
	linemesh.global_position = location
	linemesh.global_scale(Vector3(0.2, 0.2, length))
	linemesh.look_at_from_position(location, endOffset, Vector3.LEFT)
	

	
	
func addNewEdge(parent: String, child: String, pgInstance: ProofGraph):
	var pID = get_node("ProofGraph/"+parent)
	var cID = get_node("ProofGraph/"+child)
	
	pgInstance.addEdge(pID.getID(), cID.getID())
	createGraphicEdge(pID.getPosition(), cID.getPosition(), pID.getID(), cID.getID())
	
func removeBadEdge(parent: String, child: String, pgInstance: ProofGraph):
	var pID = get_node("ProofGraph/"+parent)
	var cID = get_node("ProofGraph/"+child)
	pgInstance.removeEdge(pID.getID(), cID.getID())
	var badEdge = get_node("ProofGraph/"+parent+"/"+parent+child)
	badEdge.queue_free()
	
func removeBadNode(parent: String, pgInstance: ProofGraph):
	var pID = get_node("ProofGraph/"+parent)
	pgInstance.removeNode(pID.getID())
	pID.queue_free()
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(5).timeout 
	var pgInstance = initializeProofGraph()
	addNewLogNode(Vector3(-8,12,0), pgInstance)
	await get_tree().create_timer(2).timeout 
	addNewLogNode(Vector3(8,6,0), pgInstance)
	await get_tree().create_timer(2).timeout 
	addNewLogNode(Vector3(0,-3,0), pgInstance)
	await get_tree().create_timer(2).timeout 
	
	addDataToNode(0, "p")
	await get_tree().create_timer(2).timeout 
	addDataToNode(1, "p→q")
	await get_tree().create_timer(2).timeout 
	addDataToNode(2, "q")
	await get_tree().create_timer(2).timeout 
	
	addDataToNode(0, "a")
	await get_tree().create_timer(2).timeout 
	addDataToNode(1, "a→q")
	await get_tree().create_timer(2).timeout

	addNewEdge("0", "2", pgInstance)
	await get_tree().create_timer(2).timeout 
	addNewEdge("1", "0", pgInstance)
	await get_tree().create_timer(4).timeout
	
	removeBadEdge("1", "0", pgInstance)
	await get_tree().create_timer(2).timeout
	addNewEdge("1", "2", pgInstance)
	await get_tree().create_timer(4).timeout
	
	removeBadNode("0", pgInstance)
	await get_tree().create_timer(2).timeout
	removeBadNode("1", pgInstance)
	await get_tree().create_timer(2).timeout
	removeBadNode("2", pgInstance)
	
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
