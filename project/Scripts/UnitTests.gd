extends Node

#Test addNode
func test_addNode():
	var graph = ProofGraph.new()
	graph.set_name("ProofGraph")
	self.add_child(graph)
	
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
	var maxLocationPos = 1000
	var maxLocationNeg = -1000
	graph.addNode(Vector3(1001, 20, 0))
	get_node("ProofGraph/10").setData("x")
	graph.addNode(Vector3(20, -1001, 0))
	get_node("ProofGraph/11").setData("y")
	graph.addNode(Vector3(-100, -20, -1001.5))
	get_node("ProofGraph/12").setData("z")
	
	if get_node("ProofGraph/10").get_position().x > maxLocationPos or get_node("ProofGraph/10").get_position().x < maxLocationNeg:
		print("Cannot add node at this location. X coordinate is over the limit")
		graph.removeNode(get_node("ProofGraph/10"))
		assert(graph.getNodeCount() == 12)
	
	if get_node("ProofGraph/11").get_position().y > maxLocationPos or get_node("ProofGraph/11").get_position().y < maxLocationNeg:
		print("Cannot add node at this location. Y coordinate is over the limit")
		graph.removeNode(get_node("ProofGraph/11"))
		assert(graph.getNodeCount() == 11)
	
	if get_node("ProofGraph/12").get_position().z > maxLocationPos or get_node("ProofGraph/12").get_position().z < maxLocationNeg:
		print("Cannot add node at this location. Z coordinate is over the limit")
		graph.removeNode(get_node("ProofGraph/12"))
		assert(graph.getNodeCount() == 10)

#Test addEdge
func test_addEdge():
	var graph = ProofGraph.new()
	graph.set_name("ProofGraph")
	self.add_child(graph)
	
	#test addEdge at positive locations
	graph.addNode(Vector3(60, 60, 0))
	graph.addNode(Vector3(61, 50, 0))
	get_node("ProofGraph/0").setData("p")
	get_node("ProofGraph/1").setData("q")
	graph.addEdge(get_node("ProofGraph/0"), get_node("ProofGraph/1"))
	assert(get_node("ProofGraph/0").isChild(get_node("ProofGraph/1")))
	
	#test addEdge at negative locations
	graph.addNode(Vector3(-18, -5, 0))
	graph.addNode(Vector3(-20, -20, 0))
	get_node("ProofGraph/2").setData("g")
	get_node("ProofGraph/3").setData("h")
	graph.addEdge(get_node("ProofGraph/2"), get_node("ProofGraph/3"))
	assert(get_node("ProofGraph/2").isChild(get_node("ProofGraph/3")))
	
	graph.addNode(Vector3(-30, 35, 0))
	graph.addNode(Vector3(-32, 20, 0))
	get_node("ProofGraph/4").setData("a")
	get_node("ProofGraph/5").setData("b")
	graph.addEdge(get_node("ProofGraph/4"), get_node("ProofGraph/5"))
	assert(get_node("ProofGraph/4").isChild(get_node("ProofGraph/5")))
	
	#test addEdge at floating point locations
	graph.addNode(Vector3(40.5, 40.5, 0))
	graph.addNode(Vector3(41.5, 15.5, 0))
	get_node("ProofGraph/6").setData("c")
	get_node("ProofGraph/7").setData("d")
	graph.addEdge(get_node("ProofGraph/6"), get_node("ProofGraph/7"))
	assert(get_node("ProofGraph/6").isChild(get_node("ProofGraph/7")))
	
	graph.addNode(Vector3(10.5, 15.5, 0))
	graph.addNode(Vector3(-5.5, -10.5, 0))
	get_node("ProofGraph/8").setData("e")
	get_node("ProofGraph/9").setData("f")
	graph.addEdge(get_node("ProofGraph/8"), get_node("ProofGraph/9"))
	assert(get_node("ProofGraph/8").isChild(get_node("ProofGraph/9")))
	
	#test addEdge at massive locations
	graph.addNode(Vector3(190, 180, 0))
	graph.addNode(Vector3(185, 170, 0))
	get_node("ProofGraph/10").setData("g")
	get_node("ProofGraph/11").setData("h")
	graph.addEdge(get_node("ProofGraph/10"), get_node("ProofGraph/11"))
	assert(get_node("ProofGraph/10").isChild(get_node("ProofGraph/11")))
	
	graph.addNode(Vector3(-185, -170, 0))
	graph.addNode(Vector3(-190, -180, 0))
	get_node("ProofGraph/12").setData("i")
	get_node("ProofGraph/13").setData("j")
	graph.addEdge(get_node("ProofGraph/12"), get_node("ProofGraph/13"))
	assert(get_node("ProofGraph/12").isChild(get_node("ProofGraph/13")))
	
	#test addNode at illegal locations
	var maxLocationPos = 1000
	var maxLocationNeg = -1000
	graph.addNode(Vector3(1001, 40, 0))
	get_node("ProofGraph/14").setData("¬x")
	graph.addNode(Vector3(1001, 30, 0))
	get_node("ProofGraph/15").setData("¬y")
	graph.addEdge(get_node("ProofGraph/14"), get_node("ProofGraph/15"))
	
	#Illegal X cooridinate
	if get_node("ProofGraph/14").get_position().x > maxLocationPos or get_node("ProofGraph/14").get_position().x < maxLocationNeg or get_node("ProofGraph/15").get_position().x > maxLocationPos or get_node("ProofGraph/15").get_position().x < maxLocationNeg:
		print("Cannot add edge at this location. There's at least one node over the limit at the X coordinate")
		graph.removeEdge(get_node("ProofGraph/14"), get_node("ProofGraph/15"))
		graph.removeNode(get_node("ProofGraph/14"))
		graph.removeNode(get_node("ProofGraph/15"))
		assert(graph.getNodeCount() == 14)
	
	#Illegal Y cooridinate
	graph.addNode(Vector3(40, 1011, 0))
	get_node("ProofGraph/16").setData("¬a")
	graph.addNode(Vector3(40, 1001, 0))
	get_node("ProofGraph/17").setData("¬b")
	graph.addEdge(get_node("ProofGraph/16"), get_node("ProofGraph/17"))
	
	if get_node("ProofGraph/16").get_position().y > maxLocationPos or get_node("ProofGraph/16").get_position().y < maxLocationNeg or get_node("ProofGraph/17").get_position().y > maxLocationPos or get_node("ProofGraph/17").get_position().y < maxLocationNeg:
		print("Cannot add edge at this location. There's at least one node over the limit at the Y coordinate")
		graph.removeEdge(get_node("ProofGraph/16"), get_node("ProofGraph/17"))
		graph.removeNode(get_node("ProofGraph/16"))
		graph.removeNode(get_node("ProofGraph/17"))
		assert(graph.getNodeCount() == 14)
	
	#Illegal Z cooridinate
	graph.addNode(Vector3(40, 40, 1001))
	get_node("ProofGraph/18").setData("¬c")
	graph.addNode(Vector3(40, 30, 1001))
	get_node("ProofGraph/19").setData("¬d")
	graph.addEdge(get_node("ProofGraph/18"), get_node("ProofGraph/19"))
	
	if get_node("ProofGraph/18").get_position().z > maxLocationPos or get_node("ProofGraph/18").get_position().z < maxLocationNeg or get_node("ProofGraph/19").get_position().z > maxLocationPos or get_node("ProofGraph/19").get_position().z < maxLocationNeg:
		print("Cannot add edge at this location. There's at least one node over the limit at the Z coordinate")
		graph.removeEdge(get_node("ProofGraph/18"), get_node("ProofGraph/19"))
		graph.removeNode(get_node("ProofGraph/18"))
		graph.removeNode(get_node("ProofGraph/19"))
		assert(graph.getNodeCount() == 14)

#Test removeNode
func test_removeNode():
	var graph = ProofGraph.new()
	graph.set_name("ProofGraph")
	self.add_child(graph)
	
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

#Test removeEdge
func test_removeEdge():
	var graph = ProofGraph.new()
	graph.set_name("ProofGraph")
	self.add_child(graph)
	
	#test removeEdge at positive locations
	graph.addNode(Vector3(80, 60, 0))
	graph.addNode(Vector3(81, 50, 0))
	get_node("ProofGraph/0").setData("pvq")
	get_node("ProofGraph/1").setData("avb")
	graph.addEdge(get_node("ProofGraph/0"), get_node("ProofGraph/1"))
	graph.removeEdge(get_node("ProofGraph/0"), get_node("ProofGraph/1"))
	assert(graph.getNodeCount() == 2)
	
	#test removeEdge at negative locations
	graph.addNode(Vector3(-80, 60, 0))
	graph.addNode(Vector3(-81, 50, 0))
	get_node("ProofGraph/2").setData("cvd")
	get_node("ProofGraph/3").setData("evf")
	graph.addEdge(get_node("ProofGraph/2"), get_node("ProofGraph/3"))
	graph.removeEdge(get_node("ProofGraph/2"), get_node("ProofGraph/3"))
	assert(graph.getNodeCount() == 4)
	
	graph.addNode(Vector3(-80, -50, 0))
	graph.addNode(Vector3(-81, -60, 0))
	get_node("ProofGraph/4").setData("gvh")
	get_node("ProofGraph/5").setData("ivj")
	graph.addEdge(get_node("ProofGraph/4"), get_node("ProofGraph/5"))
	graph.removeEdge(get_node("ProofGraph/4"), get_node("ProofGraph/5"))
	assert(graph.getNodeCount() == 6)
	
	graph.addNode(Vector3(90, -50, 0))
	graph.addNode(Vector3(91, -60, 0))
	get_node("ProofGraph/6").setData("kvl")
	get_node("ProofGraph/7").setData("mvn")
	graph.addEdge(get_node("ProofGraph/6"), get_node("ProofGraph/7"))
	graph.removeEdge(get_node("ProofGraph/6"), get_node("ProofGraph/7"))
	assert(graph.getNodeCount() == 8)
	
	#test removeEdge at floating point locations
	graph.addNode(Vector3(50.5, 60.5, 0))
	graph.addNode(Vector3(51.5, 50.5, 0))
	get_node("ProofGraph/8").setData("ovp")
	get_node("ProofGraph/9").setData("qvr")
	graph.addEdge(get_node("ProofGraph/8"), get_node("ProofGraph/9"))
	graph.removeEdge(get_node("ProofGraph/8"), get_node("ProofGraph/9"))
	assert(graph.getNodeCount() == 10)
	
	graph.addNode(Vector3(-50.5, -50.5, 0))
	graph.addNode(Vector3(-51.5, -60.5, 0))
	get_node("ProofGraph/10").setData("svt")
	get_node("ProofGraph/11").setData("uvw")
	graph.addEdge(get_node("ProofGraph/10"), get_node("ProofGraph/11"))
	graph.removeEdge(get_node("ProofGraph/10"), get_node("ProofGraph/11"))
	assert(graph.getNodeCount() == 12)
	
	graph.addNode(Vector3(70.5, -50.5, 0))
	graph.addNode(Vector3(71.5, -60.5, 0))
	get_node("ProofGraph/12").setData("xvy")
	get_node("ProofGraph/13").setData("zva")
	graph.addEdge(get_node("ProofGraph/12"), get_node("ProofGraph/13"))
	graph.removeEdge(get_node("ProofGraph/12"), get_node("ProofGraph/13"))
	assert(graph.getNodeCount() == 14)
	
	#test removeEdge at massive locations
	graph.addNode(Vector3(300, 300.5, 0))
	graph.addNode(Vector3(301, 290, 0))
	get_node("ProofGraph/14").setData("a→b")
	get_node("ProofGraph/15").setData("c→d")
	graph.addEdge(get_node("ProofGraph/14"), get_node("ProofGraph/15"))
	graph.removeEdge(get_node("ProofGraph/14"), get_node("ProofGraph/15"))
	assert(graph.getNodeCount() == 16)
	
	graph.addNode(Vector3(-300.5, -290, 0))
	graph.addNode(Vector3(-301.5, -300, 0))
	get_node("ProofGraph/16").setData("e→f")
	get_node("ProofGraph/17").setData("g→h")
	graph.addEdge(get_node("ProofGraph/16"), get_node("ProofGraph/17"))
	graph.removeEdge(get_node("ProofGraph/16"), get_node("ProofGraph/17"))
	assert(graph.getNodeCount() == 18)
	
	graph.addNode(Vector3(300.5, -290, 0))
	graph.addNode(Vector3(301.5, -300, 0))
	get_node("ProofGraph/18").setData("i→j")
	get_node("ProofGraph/19").setData("k→l")
	graph.addEdge(get_node("ProofGraph/18"), get_node("ProofGraph/19"))
	graph.removeEdge(get_node("ProofGraph/18"), get_node("ProofGraph/19"))
	assert(graph.getNodeCount() == 20)

#Test removeNodeWithoutEdges
func test_removeNodeWithoutEdges():
	var graph = ProofGraph.new()
	graph.set_name("ProofGraph")
	self.add_child(graph)
	
	#test removeNodeWithoutEdges at positive locations
	graph.addNode(Vector3(40, 50, 0))
	get_node("ProofGraph/0").setData("t")
	assert(graph.getNodeCount() == 1)
	graph.addNode(Vector3(41, 30, 0))
	get_node("ProofGraph/1").setData("u")
	assert(graph.getNodeCount() == 2)
	graph.addNode(Vector3(42, 10, 0))
	get_node("ProofGraph/2").setData("v")
	assert(graph.getNodeCount() == 3)
	graph.addNode(Vector3(61, 10, 0))
	get_node("ProofGraph/3").setData("w")
	assert(graph.getNodeCount() == 4)
	
	graph.addEdge(get_node("ProofGraph/0"), get_node("ProofGraph/1"))
	assert(get_node("ProofGraph/0").isChild(get_node("ProofGraph/1")))
	graph.addEdge(get_node("ProofGraph/1"), get_node("ProofGraph/2"))
	assert(get_node("ProofGraph/1").isChild(get_node("ProofGraph/2")))
	
	if not get_node("ProofGraph/3").isChild(get_node("ProofGraph/1")):
		graph.removeNode(get_node("ProofGraph/3"))
		assert(graph.getNodeCount() == 3)
	
	#test removeNodeWithoutEdges at negative locations
	graph.addNode(Vector3(-20, 10, 0))
	get_node("ProofGraph/4").setData("¬t")
	assert(graph.getNodeCount() == 4)
	graph.addNode(Vector3(-21, -10, 0))
	get_node("ProofGraph/5").setData("¬u")
	assert(graph.getNodeCount() == 5)
	graph.addNode(Vector3(20, -30, 0))
	get_node("ProofGraph/6").setData("¬v")
	assert(graph.getNodeCount() == 6)
	graph.addNode(Vector3(-30, -30, 0))
	get_node("ProofGraph/7").setData("¬w")
	assert(graph.getNodeCount() == 7)

	graph.addEdge(get_node("ProofGraph/4"), get_node("ProofGraph/5"))
	assert(get_node("ProofGraph/4").isChild(get_node("ProofGraph/5")))
	graph.addEdge(get_node("ProofGraph/5"), get_node("ProofGraph/7"))
	assert(get_node("ProofGraph/5").isChild(get_node("ProofGraph/7")))

	if not get_node("ProofGraph/6").isChild(get_node("ProofGraph/5")):
		graph.removeNode(get_node("ProofGraph/6"))
		assert(graph.getNodeCount() == 6)

	#test removeNodeWithoutEdges at floating point locations
	graph.addNode(Vector3(20.5, 40.5, 0))
	get_node("ProofGraph/8").setData("g")
	assert(graph.getNodeCount() == 7)
	graph.addNode(Vector3(21.5, 30.5, 0))
	get_node("ProofGraph/9").setData("h")
	assert(graph.getNodeCount() == 8)
	graph.addNode(Vector3(5.5, -1.5, 0))
	get_node("ProofGraph/10").setData("i")
	assert(graph.getNodeCount() == 9)
	graph.addNode(Vector3(-5.5, -1.5, 0))
	get_node("ProofGraph/11").setData("j")
	assert(graph.getNodeCount() == 10)

	graph.addEdge(get_node("ProofGraph/8"), get_node("ProofGraph/9"))
	assert(get_node("ProofGraph/8").isChild(get_node("ProofGraph/9")))
	graph.addEdge(get_node("ProofGraph/8"), get_node("ProofGraph/10"))
	assert(get_node("ProofGraph/8").isChild(get_node("ProofGraph/10")))

	if not get_node("ProofGraph/11").isChild(get_node("ProofGraph/8")):
		graph.removeNode(get_node("ProofGraph/11"))
		assert(graph.getNodeCount() == 9)

	#test removeNodeWithoutEdges at massive locations
	graph.addNode(Vector3(410.5, 410.5, 0))
	get_node("ProofGraph/12").setData("¬g")
	assert(graph.getNodeCount() == 10)
	graph.addNode(Vector3(411.5, 390, 0))
	get_node("ProofGraph/13").setData("¬h")
	assert(graph.getNodeCount() == 11)
	graph.addNode(Vector3(430, 390.5, 0))
	get_node("ProofGraph/14").setData("¬i")
	assert(graph.getNodeCount() == 12)
	graph.addNode(Vector3(390, 390, 0))
	get_node("ProofGraph/15").setData("¬j")
	assert(graph.getNodeCount() == 13)

	graph.addEdge(get_node("ProofGraph/12"), get_node("ProofGraph/13"))
	assert(get_node("ProofGraph/12").isChild(get_node("ProofGraph/13")))
	graph.addEdge(get_node("ProofGraph/12"), get_node("ProofGraph/15"))
	assert(get_node("ProofGraph/12").isChild(get_node("ProofGraph/15")))

	if not get_node("ProofGraph/14").isChild(get_node("ProofGraph/12")):
		graph.removeNode(get_node("ProofGraph/14"))
		assert(graph.getNodeCount() == 12)

	graph.addNode(Vector3(-410, -370, 0))
	get_node("ProofGraph/16").setData("¬l")
	assert(graph.getNodeCount() == 13)
	graph.addNode(Vector3(-400, -390.5, 0))
	get_node("ProofGraph/17").setData("¬m")
	assert(graph.getNodeCount() == 14)
	graph.addNode(Vector3(-390.5, -410, 0))
	get_node("ProofGraph/18").setData("¬n")
	assert(graph.getNodeCount() == 15)
	graph.addNode(Vector3(-370.5, -430.5, 0))
	get_node("ProofGraph/19").setData("¬o")
	assert(graph.getNodeCount() == 16)

	graph.addEdge(get_node("ProofGraph/16"), get_node("ProofGraph/17"))
	assert(get_node("ProofGraph/16").isChild(get_node("ProofGraph/17")))
	graph.addEdge(get_node("ProofGraph/17"), get_node("ProofGraph/18"))
	assert(get_node("ProofGraph/17").isChild(get_node("ProofGraph/18")))

	if not get_node("ProofGraph/19").isChild(get_node("ProofGraph/18")):
		graph.removeNode(get_node("ProofGraph/19"))
		assert(graph.getNodeCount() == 15)

func run_tests():
	test_addNode()
#	test_addEdge()
#	test_removeNode()
#	test_removeEdge()
#	test_removeNodeWithoutEdges()

func _ready():
	run_tests()
