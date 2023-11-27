extends Node

@export var pg: ProofGraph
var interface : XRInterface

func initializeProofGraph():
	pg = ProofGraph.new()
	pg.set_name("ProofGraph")
	self.add_child(pg)
	return pg
	
func demo():
	pg.addNode(Vector3(-2,3,-6))
	pg.addNode(Vector3(2,1.5,-6))
	pg.addNode(Vector3(0,-1.5,-6))
	
	get_node("ProofGraph/0").setData("p")
	get_node("ProofGraph/1").setData("p→q")
	get_node("ProofGraph/2").setData("q")
	
	pg.addEdge(get_node("ProofGraph/0"), get_node("ProofGraph/2"))
	pg.addEdge(get_node("ProofGraph/1"), get_node("ProofGraph/2"))
	
	get_node("ProofGraph/0").setJustification("assume", "Assume")
	get_node("ProofGraph/1").setJustification("assume", "Assume")
	get_node("ProofGraph/2").setJustification("ifE", "→E")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pg = initializeProofGraph()
	
	interface = XRServer.find_interface("OpenXR")
	if interface and interface.is_initialized():
		get_viewport().use_xr = true
	
	var vrStart = load("res://Scenes/vr_player.tscn").instantiate()
	self.add_child(vrStart)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	pass
