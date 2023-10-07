
#include <iostream>
#include <list>
#include <map>

#include "Proofgraph.hpp"

ProofNode::ProofNode(){
    nodeID = 0;
    location = Vector3(0,0,0);
    data = 0; 
}

ProofNode::ProofNode(int nodeID_, const Vector3& location_, int data_){
    this->nodeID = nodeID_;
    this->location = location_;
    this->data = data_;
}

// Constructor, creates empty proof graph
ProofGraph::ProofGraph(){
    nodeCount = 0;
    nodeMap = std::map<int, ProofNode>();
}

void ProofGraph::displayNodeList(){
    for (auto& tempNode : nodeMap){
        std::cout << tempNode.second.nodeID << ": ";
        for(auto& i : tempNode.second.neighbors){
            std::cout << i->nodeID << " ";
        }
        std::cout << "\n";
    }
}

void ProofGraph::addNode(const Vector3& location, int data){
    ProofNode temp = ProofNode(this->nodeCount, location, data);
    nodeMap[nodeCount] = temp;
    nodeCount++;
}

// Needs better check for node validity
void ProofGraph::addEdge(int start, int end){
    if(nodeMap.find(start) == nodeMap.end() || nodeMap.find(end) == nodeMap.end()){
        std::cout << "Nodes not found\n ";
    }
    else{
        nodeMap[start].neighbors.insert(&(nodeMap[end]));
        nodeMap[end].neighbors.insert(&(nodeMap[start]));
    }
}

// Needs checks for node validity
void ProofGraph::removeNode(int deleteID){
    ProofNode* temp = &nodeMap[deleteID];
    nodeMap.erase(deleteID);
    for(auto& i : temp->neighbors){
        i->neighbors.erase(temp);
    }
}

void ProofGraph::_bind_methods() {
    ClassDB::bind_method(D_METHOD("addNode", "location", "data"), &ProofGraph::addNode);
    ClassDB::bind_method(D_METHOD("addEdge", "startNode", "endNode"), &ProofGraph::addEdge);
    ClassDB::bind_method(D_METHOD("removeNode", "node"), &ProofGraph::removeNode);
}


// int main(){
//     ProofGraph graph = ProofGraph();
//     graph.addNode(std::make_tuple(0,0,0), 0);
//     graph.addNode(std::make_tuple(0,1,1), 1);
//     graph.addNode(std::make_tuple(0,1,1), 2);
//     graph.addNode(std::make_tuple(2,1,1), 3);
//     graph.displayNodeList();
//     std::cout << "--------\n";
//     graph.addEdge(0,1);
//     graph.addEdge(0,2);
//     graph.addEdge(2,3);
//     graph.addEdge(3,0);
//     //graph.addEdge(0,5);
//     graph.displayNodeList();
//     std::cout << "--------\n";
//     graph.removeNode(0);
//     graph.displayNodeList();
//     std::cout << "--------\n";
// }