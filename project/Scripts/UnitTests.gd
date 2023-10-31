extends Node

#Test addNode
func test_addNode():
	var graph = ProofGraph.new()
	for i in range(0, 50, 1):
		var nodeInfo = {"location": [i, i+1, i+2], "node_id": i}
		graph.addNode(nodeInfo)
	
	var currGraph = graph.get_node_map()
	for i in range(50, 0, -1):
		var curr = currGraph[i]
		assert(curr.node_id == i)
		assert(curr.location[0] == i)
		assert(curr.location[1] == i+1)
		assert(curr.location[2] == i+2)
	assert(graph.get_size() == 50)
	
	#test addNode at negative locations
	graph.addNode(Vector3(-8, -8, 0))
	assert(graph.get_size() == 1)
	graph.addNode(Vector3(-8, 8, 0))
	assert(graph.get_size() == 2)
	graph.addNode(Vector3(8, -8, 0))
	assert(graph.get_size() == 3)
	
	#test addNode at floating point locations
	graph.addNode(Vector3(4.5, 7.5, 0))
	assert(graph.get_size() == 4)
	graph.addNode(Vector3(4.5, 7, 0))
	assert(graph.get_size() == 5)
	graph.addNode(Vector3(4, 7.5, 0))
	assert(graph.get_size() == 6)
	
	#test addNode at  massive locations
	graph.addNode(Vector3(200, 200, 0))
	assert(graph.get_size() == 7)
	graph.addNode(Vector3(200, 8, 0))
	assert(graph.get_size() == 8)
	graph.addNode(Vector3(8, 200, 0))
	assert(graph.get_size() == 9)

#Test addEdge
func test_addEdge():
	var graph = ProofGraph.new()
	for i in range(0, 50, 1):
		var nodeInfo = {"location": [i, i+1, i+2], "node_id": i}
		graph.addNode(nodeInfo)
	for i in range(0, 50, 1):
		if i == 12:
			continue
		graph.addEdge(get_node("ProofGraph/12"), get_node("ProofGraph/i"))
	var graphNodes = graph.get_node_map()
	var twelve = graphNodes[12]
	for curr in graphNodes:
		if curr.second == twelve:
			assert(curr.second.neighbors.size() == 49)
		else:
			assert(curr.second.neighbors.size() == 1)
	
	#test addEdge at negative locations
	graph.addNode(Vector3(-10, -10, 0))
	graph.addNode(Vector3(-5, -5, 0))
	get_node("ProofGraph/0").setData("p")
	get_node("ProofGraph/1").setData("q")
	graph.addEdge(get_node("ProofGraph/0"), get_node("ProofGraph/1"))
	assert(get_node("ProofGraph/0").setData("p").logChildren.get_size() == 1)
	assert(get_node("ProofGraph/1").setData("q").logChildren.get_size() == 1)
	
	graph.addNode(Vector3(-2, -2, 0))
	graph.addNode(Vector3(2, 2, 0))
	get_node("ProofGraph/2").setData("a")
	get_node("ProofGraph/3").setData("b")
	graph.addEdge(get_node("ProofGraph/2"), get_node("ProofGraph/3"))
	assert(get_node("ProofGraph/2").setData("a").logChildren.get_size() == 1)
	assert(get_node("ProofGraph/3").setData("b").logChildren.get_size() == 1)
	
	#test addEdge at floating point locations
	graph.addNode(Vector3(5.5, 5.5, 0))
	graph.addNode(Vector3(10, 10, 0))
	get_node("ProofGraph/4").setData("c")
	get_node("ProofGraph/5").setData("d")
	graph.addEdge(get_node("ProofGraph/4"), get_node("ProofGraph/5"))
	assert(get_node("ProofGraph/4").setData("c").logChildren.get_size() == 1)
	assert(get_node("ProofGraph/5").setData("d").logChildren.get_size() == 1)
	
	graph.addNode(Vector3(15.5, 15.5, 0))
	graph.addNode(Vector3(20.5, 15.5, 0))
	get_node("ProofGraph/6").setData("e")
	get_node("ProofGraph/7").setData("f")
	graph.addEdge(get_node("ProofGraph/6"), get_node("ProofGraph/7"))
	assert(get_node("ProofGraph/6").setData("e").logChildren.get_size() == 1)
	assert(get_node("ProofGraph/7").setData("f").logChildren.get_size() == 1)
	
	#test addEdge at massive locations
	graph.addNode(Vector3(180, 180, 0))
	graph.addNode(Vector3(190, 180, 0))
	get_node("ProofGraph/8").setData("g")
	get_node("ProofGraph/9").setData("h")
	graph.addEdge(get_node("ProofGraph/8"), get_node("ProofGraph/9"))
	assert(get_node("ProofGraph/8").setData("g").logChildren.get_size() == 1)
	assert(get_node("ProofGraph/9").setData("h").logChildren.get_size() == 1)
	
	graph.addNode(Vector3(-180, -180, 0))
	graph.addNode(Vector3(-190, -180, 0))
	get_node("ProofGraph/10").setData("i")
	get_node("ProofGraph/11").setData("j")
	graph.addEdge(get_node("ProofGraph/10"), get_node("ProofGraph/11"))
	assert(get_node("ProofGraph/10").setData("i").logChildren.get_size() == 1)
	assert(get_node("ProofGraph/11").setData("j").logChildren.get_size() == 1)

#Test removeNode
func test_removeNode():
	var graph = ProofGraph.new()
	var answer = ProofGraph.new()
	for i in range(0, 50, 1):
		var nodeInfo = {"location": [i, i+1, i+2], "node_id": i}
		answer.addNode(nodeInfo) 
		graph.addNode(nodeInfo)
	for i in range(0, 50, 1):
		if i == 12:
			continue
		graph.addEdge(get_node("ProofGraph/12"), get_node("ProofGraph/i"))
	graph.removeNode(get_node("ProofGraph/12"))
	answer.removeNode(get_node("ProofGraph/12"))
	assert(graph.representation, answer.representation)
	
	#test removeNode at negative locations
	graph.addNode(Vector3(-8, -8, 0))
	graph.addNode(Vector3(-8, 8, 0))
	graph.addNode(Vector3(8, -8, 0))
	get_node("ProofGraph/0").setData("p")
	get_node("ProofGraph/1").setData("q")
	get_node("ProofGraph/2").setData("r")
	assert(graph.get_size() == 3)
	graph.removeNode(get_node("ProofGraph/0"))
	assert(graph.get_size() == 2)
	graph.removeNode(get_node("ProofGraph/1"))
	assert(graph.get_size() == 1)
	graph.removeNode(get_node("ProofGraph/2"))
	assert(graph.get_size() == 0)
	
	#test removeNode at floating point locations
	graph.addNode(Vector3(8.5, 8.5, 0))
	graph.addNode(Vector3(6.5, 6, 0))
	graph.addNode(Vector3(4, 4.5, 0))
	get_node("ProofGraph/3").setData("pvq")
	get_node("ProofGraph/4").setData("qvp")
	get_node("ProofGraph/5").setData("rvq")
	assert(graph.get_size() == 3)
	graph.removeNode(get_node("ProofGraph/3"))
	assert(graph.get_size() == 2)
	graph.removeNode(get_node("ProofGraph/4"))
	assert(graph.get_size() == 1)
	graph.removeNode(get_node("ProofGraph/5"))
	assert(graph.get_size() == 0)
	
	#test removeNode at massive locations
	graph.addNode(Vector3(100, 100, 0))
	graph.addNode(Vector3(150, 150, 0))
	graph.addNode(Vector3(200, 200, 0))
	get_node("ProofGraph/6").setData("avb")
	get_node("ProofGraph/7").setData("bvc")
	get_node("ProofGraph/8").setData("avc")
	assert(graph.get_size() == 3)
	graph.removeNode(get_node("ProofGraph/6"))
	assert(graph.get_size() == 2)
	graph.removeNode(get_node("ProofGraph/7"))
	assert(graph.get_size() == 1)
	graph.removeNode(get_node("ProofGraph/8"))
	assert(graph.get_size() == 0)

#Test removeNodeWithoutEdges
func test_removeNodeWithoutEdges():
	var graph = ProofGraph.new()
	var answer = ProofGraph.new()
	graph.removeNode(get_node("ProofGraph/0"))
	assert(graph.getNodeMap().size() == 0)
	var nodeInfo = {"location": [0, 0, 0], "node_id": 0}
	graph.addNode(nodeInfo)
	assert(graph.getNodeMap().size() == 0)
	graph = ProofGraph.new()
	
	for i in range(0, 50 ,1):
		answer.addNode(nodeInfo)
		graph.addNode(nodeInfo)
	
	for i in range(0, 50, 1):
		if i%2 != 0:
			graph.removeNode(get_node("ProofGraph/i"))
	
	var graphNodes = graph.getNodeMap()
	var answerNodes = answer.getNodeMap()
	
	for i in range(0, 50, 1):
		if i%2 == 0:
			assert(graphNodes.find(i) == graphNodes.end() == false)
			answer = answerNodes[i]
			var graphNode = graphNodes[i]
			assert(answer.location[0] == graphNode.location[0])
			assert(answer.location[1] == graphNode.location[1])
			assert(answer.location[2] == graphNode.location[2])
		
		else:
			assert(graphNodes.find(i) == graphNodes.end() == true)
		assert(graphNodes.size() == 25)

func run_tests():
	test_addNode()
	test_addEdge()
	test_removeNode()
	test_removeNodeWithoutEdges()

func ready():
	run_tests()
