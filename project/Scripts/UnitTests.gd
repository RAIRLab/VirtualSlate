extends Node

#Test addNode
func test_addNode():
	var graph = ProofGraph.new()
	graph.set_name("ProofGraph")
	self.add_child(graph)
#	var nodeInfo = {"location": [1, 2, 3], "node_id": 0}
#	graph.addNode(nodeInfo)
#
#	var currGraph = graph.get_node_map()
#	for i in range(50, 0, -1):
#		var curr = currGraph[i]
#		assert(curr.node_id == i)
#		assert(curr.location[0] == i)
#		assert(curr.location[1] == i+1)
#		assert(curr.location[2] == i+2)
#	assert(graph.getNodeCount() == 50)
	
	#test addNode at positive locations
	graph.addNode(Vector3(30, 30, 0))
	get_node("ProofGraph/0").setData("z")
	assert(graph.getNodeCount() == 1)
	
	#test addNode at negative locations
	graph.addNode(Vector3(-8, -8, 0))
	get_node("ProofGraph/1").setData("d")
	assert(graph.getNodeCount() == 2)
	graph.addNode(Vector3(-8, 8, 0))
	get_node("ProofGraph/2").setData("e")
	assert(graph.getNodeCount() == 3)
	graph.addNode(Vector3(8, -8, 0))
	get_node("ProofGraph/3").setData("f")
	assert(graph.getNodeCount() == 4)
	
	#test addNode at floating point locations
	graph.addNode(Vector3(4.5, 7.5, 0))
	get_node("ProofGraph/4").setData("a")
	assert(graph.getNodeCount() == 5)
	graph.addNode(Vector3(14.5, 7, 0))
	get_node("ProofGraph/5").setData("b")
	assert(graph.getNodeCount() == 6)
	graph.addNode(Vector3(29, 7.5, 0))
	get_node("ProofGraph/6").setData("c")
	assert(graph.getNodeCount() == 7)
	
	#test addNode at massive locations
	graph.addNode(Vector3(200, 200, 0))
	get_node("ProofGraph/7").setData("t")
	assert(graph.getNodeCount() == 8)
	graph.addNode(Vector3(200, 8, 0))
	get_node("ProofGraph/8").setData("u")
	assert(graph.getNodeCount() == 9)
	graph.addNode(Vector3(8, 200, 0))
	get_node("ProofGraph/9").setData("v")
	assert(graph.getNodeCount() == 10)
	
	#test addNode at illegal locations
#	var maxLocationPos = 1000
#	var maxLocationNeg = -1000
#	graph.addNode(Vector3(1001, 20, 0))
#	graph.addNode(Vector3(20, 1001, 0))
#	graph.addNode(Vector3(-1001, -20, 0))
#	graph.addNode(Vector3(20, 1001, 0))
#	graph.addNode(Vector3(1001.5, 20, 0))
#	graph.addNode(Vector3(20, 1001.5, 0))

#Test addEdge
func test_addEdge():
	var graph = ProofGraph.new()
	graph.set_name("ProofGraph")
	self.add_child(graph)
#	var nodeInfo = {"location": [1, 2, 3], "node_id": 1}
#	graph.addNode(nodeInfo)
#	for i in range(0, 50, 1):
#		if i == 12:
#			continue
#		graph.addEdge(get_node("ProofGraph/12"), get_node("ProofGraph/i"))
#	var graphNodes = graph.get_node_map()
#	var twelve = graphNodes[12]
#	for curr in graphNodes:
#		if curr.second == twelve:
#			assert(curr.second.neighbors.size() == 49)
#		else:
#			assert(curr.second.neighbors.size() == 1)
	
	#test addEdge at positive locations
	graph.addNode(Vector3(60, 60, 0))
	graph.addNode(Vector3(61, 50, 0))
	get_node("ProofGraph/0").setData("p")
	get_node("ProofGraph/1").setData("q")
	graph.addEdge(get_node("ProofGraph/0"), get_node("ProofGraph/1"))
	assert(get_node("ProofGraph/0").logChildren.getNodeCount() == 1)
	assert(get_node("ProofGraph/1").logParents.getNodeCount() == 1)
	
	#test addEdge at negative locations
	graph.addNode(Vector3(-18, -5, 0))
	graph.addNode(Vector3(-20, -20, 0))
	get_node("ProofGraph/2").setData("g")
	get_node("ProofGraph/3").setData("h")
	graph.addEdge(get_node("ProofGraph/2"), get_node("ProofGraph/3"))
	assert(get_node("ProofGraph/0").logChildren.getNodeCount() == 1)
	assert(get_node("ProofGraph/1").logParents.getNodeCount() == 1)
	
	graph.addNode(Vector3(-30, 35, 0))
	graph.addNode(Vector3(-32, 20, 0))
	get_node("ProofGraph/4").setData("a")
	get_node("ProofGraph/5").setData("b")
	graph.addEdge(get_node("ProofGraph/4"), get_node("ProofGraph/5"))
	assert(get_node("ProofGraph/2").setData("a").logChildren.getNodeCount() == 1)
	assert(get_node("ProofGraph/3").setData("b").logParents.getNodeCount() == 1)
	
	#test addEdge at floating point locations
	graph.addNode(Vector3(40.5, 40.5, 0))
	graph.addNode(Vector3(41.5, 15.5, 0))
	get_node("ProofGraph/6").setData("c")
	get_node("ProofGraph/7").setData("d")
	graph.addEdge(get_node("ProofGraph/6"), get_node("ProofGraph/7"))
	assert(get_node("ProofGraph/4").setData("c").logChildren.getNodeCount() == 1)
	assert(get_node("ProofGraph/5").setData("d").logParents.getNodeCount() == 1)
	
	graph.addNode(Vector3(10.5, 15.5, 0))
	graph.addNode(Vector3(-5.5, -10.5, 0))
	get_node("ProofGraph/8").setData("e")
	get_node("ProofGraph/9").setData("f")
	graph.addEdge(get_node("ProofGraph/8"), get_node("ProofGraph/9"))
	assert(get_node("ProofGraph/6").setData("e").logChildren.getNodeCount() == 1)
	assert(get_node("ProofGraph/7").setData("f").logParents.getNodeCount() == 1)
	
	#test addEdge at massive locations
	graph.addNode(Vector3(190, 180, 0))
	graph.addNode(Vector3(185, 170, 0))
	get_node("ProofGraph/10").setData("g")
	get_node("ProofGraph/11").setData("h")
	graph.addEdge(get_node("ProofGraph/10"), get_node("ProofGraph/11"))
	assert(get_node("ProofGraph/8").setData("g").logChildren.getNodeCount() == 1)
	assert(get_node("ProofGraph/9").setData("h").logParents.getNodeCount() == 1)
	
	graph.addNode(Vector3(-185, -170, 0))
	graph.addNode(Vector3(-190, -180, 0))
	get_node("ProofGraph/12").setData("i")
	get_node("ProofGraph/13").setData("j")
	graph.addEdge(get_node("ProofGraph/12"), get_node("ProofGraph/13"))
	assert(get_node("ProofGraph/10").setData("i").logChildren.getNodeCount() == 1)
	assert(get_node("ProofGraph/11").setData("j").logParents.getNodeCount() == 1)

#Test removeNode
func test_removeNode():
	var graph = ProofGraph.new()
	graph.set_name("ProofGraph")
	self.add_child(graph)
#	var answer = ProofGraph.new()
#	var nodeInfo = {"location": [1, 2, 3], "node_id": 2}
#	answer.addNode(nodeInfo) 
#	graph.addNode(nodeInfo)
#	for i in range(0, 50, 1):
#		if i == 12:
#			continue
#		graph.addEdge(get_node("ProofGraph/12"), get_node("ProofGraph/i"))
#	graph.removeNode(get_node("ProofGraph/12"))
#	answer.removeNode(get_node("ProofGraph/12"))
#	assert(graph.representation, answer.representation)
	
	#test removeNode at positive locations
	graph.addNode(Vector3(25, 25, 0))
	get_node("ProofGraph/0").setData("e→c")
	assert(graph.getNodeCount() == 1)
	graph.removeNode(get_node("ProofGraph/0"))
	
	#test removeNode at negative locations
	graph.addNode(Vector3(-18, -18, 0))
	get_node("ProofGraph/1").setData("p")
	assert(graph.getNodeCount() == 1)
	graph.addNode(Vector3(-18, 18, 0))
	get_node("ProofGraph/2").setData("q")
	assert(graph.getNodeCount() == 2)
	graph.addNode(Vector3(18, -18, 0))
	get_node("ProofGraph/3").setData("r")
	assert(graph.getNodeCount() == 3)
	
	graph.removeNode(get_node("ProofGraph/1"))
	assert(graph.getNodeCount() == 2)
	graph.removeNode(get_node("ProofGraph/2"))
	assert(graph.getNodeCount() == 1)
	graph.removeNode(get_node("ProofGraph/3"))
	assert(graph.getNodeCount() == 0)
	
	#test removeNode at floating point locations
	graph.addNode(Vector3(8.5, 8.5, 0))
	get_node("ProofGraph/4").setData("pvq")
	assert(graph.getNodeCount() == 1)
	graph.addNode(Vector3(6.5, 6, 0))
	get_node("ProofGraph/5").setData("qvp")
	assert(graph.getNodeCount() == 2)
	graph.addNode(Vector3(4, 4.5, 0))
	get_node("ProofGraph/6").setData("rvq")
	assert(graph.getNodeCount() == 3)
	
	graph.removeNode(get_node("ProofGraph/4"))
	assert(graph.getNodeCount() == 2)
	graph.removeNode(get_node("ProofGraph/5"))
	assert(graph.getNodeCount() == 1)
	graph.removeNode(get_node("ProofGraph/6"))
	assert(graph.getNodeCount() == 0)
	
	#test removeNode at massive locations
	graph.addNode(Vector3(100, 100, 0))
	get_node("ProofGraph/7").setData("avb")
	assert(graph.getNodeCount() == 1)
	graph.addNode(Vector3(150, 150, 0))
	get_node("ProofGraph/8").setData("bvc")
	assert(graph.getNodeCount() == 2)
	graph.addNode(Vector3(200, 200, 0))
	get_node("ProofGraph/9").setData("avc")
	assert(graph.getNodeCount() == 3)
	
	graph.removeNode(get_node("ProofGraph/7"))
	assert(graph.getNodeCount() == 2)
	graph.removeNode(get_node("ProofGraph/8"))
	assert(graph.getNodeCount() == 1)
	graph.removeNode(get_node("ProofGraph/9"))
	assert(graph.getNodeCount() == 0)

#Test removeNodeWithoutEdges
func test_removeNodeWithoutEdges():
	var graph = ProofGraph.new()
	graph.set_name("ProofGraph")
	self.add_child(graph)
#	var answer = ProofGraph.new()
#	graph.removeNode(get_node("ProofGraph/0"))
#	assert(graph.getNodeMap().size() == 0)
#	var nodeInfo = {"location": [0, 0, 0], "node_id": 0}
#	graph.addNode(nodeInfo)
#	assert(graph.getNodeMap().size() == 0)
#	graph = ProofGraph.new()
#
#	for i in range(0, 50 ,1):
#		answer.addNode(nodeInfo)
#		graph.addNode(nodeInfo)
#
#	for i in range(0, 50, 1):
#		if i%2 != 0:
#			graph.removeNode(get_node("ProofGraph/i"))
#
#	var graphNodes = graph.getNodeMap()
#	var answerNodes = answer.getNodeMap()
#
#	for i in range(0, 50, 1):
#		if i%2 == 0:
#			assert(graphNodes.find(i) == graphNodes.end() == false)
#			answer = answerNodes[i]
#			var graphNode = graphNodes[i]
#			assert(answer.location[0] == graphNode.location[0])
#			assert(answer.location[1] == graphNode.location[1])
#			assert(answer.location[2] == graphNode.location[2])
#
#		else:
#			assert(graphNodes.find(i) == graphNodes.end() == true)
#		assert(graphNodes.size() == 25)
	
	#test removeNodeWithoutEdges at negative locations
	graph.addNode(Vector3(-20, 20, 0))
	get_node("ProofGraph/0").setData("t")
	assert(graph.getNodeCount() == 1)
	graph.addNode(Vector3(-20, -10, 0))
	get_node("ProofGraph/1").setData("u")
	assert(graph.getNodeCount() == 2)
	graph.addNode(Vector3(20, -20, 0))
	get_node("ProofGraph/2").setData("v")
	assert(graph.getNodeCount() == 3)
	graph.addNode(Vector3(-30, -30, 0))
	get_node("ProofGraph/3").setData("w")
	assert(graph.getNodeCount() == 4)
	
	graph.addEdge(get_node("ProofGraph/0"), get_node("ProofGraph/1"))
	assert(get_node("ProofGraph/0").logChildren.getNodeCount() == 1)
	assert(get_node("ProofGraph/1").logParents.getNodeCount() == 1)
	graph.addEdge(get_node("ProofGraph/1"), get_node("ProofGraph/2"))
	assert(get_node("ProofGraph/1").logChildren.getNodeCount() == 1)
	assert(get_node("ProofGraph/2").logParents.getNodeCount() == 1)
	
	for i in range(graph.getNodeCount()):
		if get_node("ProofGraph/i").logChildren.getNodeCount() == 0:
			if get_node("ProofGraph/i").logParents.getNodeCount() == 0:
				graph.removeNode(get_node("ProofGraph/i"))
	
	#test removeNodeWithoutEdges at floating point locations
	graph.addNode(Vector3(40.5, 40.5, 0))
	get_node("ProofGraph/4").setData("g")
	assert(graph.getNodeCount() == 1)
	graph.addNode(Vector3(30.5, 30.5, 0))
	get_node("ProofGraph/5").setData("h")
	assert(graph.getNodeCount() == 2)
	graph.addNode(Vector3(-40.5, 40.5, 0))
	get_node("ProofGraph/6").setData("i")
	assert(graph.getNodeCount() == 3)
	graph.addNode(Vector3(-40.5, -40.5, 0))
	get_node("ProofGraph/7").setData("j")
	assert(graph.getNodeCount() == 4)
	
	graph.addEdge(get_node("ProofGraph/4"), get_node("ProofGraph/5"))
	assert(get_node("ProofGraph/4").logChildren.getNodeCount() == 1)
	assert(get_node("ProofGraph/5").logParents.getNodeCount() == 1)
	graph.addEdge(get_node("ProofGraph/5"), get_node("ProofGraph/6"))
	assert(get_node("ProofGraph/5").logChildren.getNodeCount() == 1)
	assert(get_node("ProofGraph/6").logParents.getNodeCount() == 1)
	
	for i in range(graph.getNodeCount()):
		if get_node("ProofGraph/i").logChildren.getNodeCount() == 0:
			if get_node("ProofGraph/i").logParents.getNodeCount() == 0:
				graph.removeNode(get_node("ProofGraph/i"))
	
	#test removeNodeWithoutEdges at massive locations
	graph.addNode(Vector3(410.5, 410.5, 0))
	get_node("ProofGraph/8").setData("l")
	assert(graph.getNodeCount() == 1)
	graph.addNode(Vector3(300.5, 300.5, 0))
	get_node("ProofGraph/9").setData("m")
	assert(graph.getNodeCount() == 2)
	graph.addNode(Vector3(-400.5, 400.5, 0))
	get_node("ProofGraph/10").setData("n")
	assert(graph.getNodeCount() == 3)
	graph.addNode(Vector3(-400.5, -400.5, 0))
	get_node("ProofGraph/11").setData("o")
	assert(graph.getNodeCount() == 4)
	
	graph.addEdge(get_node("ProofGraph/8"), get_node("ProofGraph/9"))
	assert(get_node("ProofGraph/8").logChildren.getNodeCount() == 1)
	assert(get_node("ProofGraph/9").logParents.getNodeCount() == 1)
	graph.addEdge(get_node("ProofGraph/9"), get_node("ProofGraph/10"))
	assert(get_node("ProofGraph/9").logChildren.getNodeCount() == 1)
	assert(get_node("ProofGraph/10").logParents.getNodeCount() == 1)
	
	for i in range(graph.getNodeCount()):
		if get_node("ProofGraph/i").logChildren.getNodeCount() == 0:
			if get_node("ProofGraph/i").logParents.getNodeCount() == 0:
				graph.removeNode(get_node("ProofGraph/i"))

func run_tests():
	test_addNode()
	test_addEdge()
	test_removeNode()
	test_removeNodeWithoutEdges()

func _ready():
	run_tests()

func _physics_process(_delta):
	pass
