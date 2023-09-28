#include <iostream>
#include <list>
#include <map>
using namespace std;


class Node{
    public:
        int nodeID;
        // Placeholder for 3D location info as I'm not sure how Godot handles it
        tuple <double, double, double> location;
        // Placeholder for formula data
        int data;
        list<Node*> neighbors;

        Node(){
            nodeID = 0;
            location = make_tuple(0,0,0);
            data = 0; 
        }
        Node(int nodeID, tuple<double, double, double> location, int data){
            this->nodeID = nodeID;
            this->location = location;
            this->data = data;
        }
};

class ProofGraph{
    int nodeCount;
    map<int, Node> nodeMap;
    public:

        // Constructor, creates empty proof graph
        ProofGraph(){
            nodeCount = 0;
        }

        void displayNodeList(){
            for (auto& tempNode : nodeMap){
                cout << tempNode.second.nodeID << ": ";
                for(auto& i : tempNode.second.neighbors){
                    cout << i->nodeID << " ";
                }
                cout << "\n";
            }
        }

        void addNode(tuple<double, double, double> location, int data){
            Node temp = Node(this->nodeCount, location, data);
            nodeMap[nodeCount] = temp;
            nodeCount++;
            //cout << "Node Count " << nodeCount << "\n";
        }

        // Needs checks for node validity
        void addEdge(int start, int end){
            nodeMap[start].neighbors.push_back(&(nodeMap[end]));
            nodeMap[end].neighbors.push_back(&(nodeMap[start]));
        }

        // Needs checks for node validity
        void removeNode(int deleteID){
            Node* temp = &nodeMap[deleteID];
            nodeMap.erase(deleteID);
            for(auto&& i : temp->neighbors){
                list<Node*>::iterator it = i->neighbors.begin();
                while(it != i->neighbors.end()){
                    if ((*it)->nodeID == temp->nodeID){
                        it = i->neighbors.erase(it);
                    }
                    else{
                        it++;
                    }

                }
            }

        }

};

int main(){
    ProofGraph graph = ProofGraph();
    graph.addNode(make_tuple(0,0,0), 0);
    graph.addNode(make_tuple(0,1,1), 1);
    graph.addNode(make_tuple(0,1,1), 2);
    graph.addNode(make_tuple(2,1,1), 3);
    graph.displayNodeList();
    cout << "--------\n";
    graph.addEdge(0,1);
    graph.addEdge(0,2);
    graph.addEdge(2,3);
    graph.displayNodeList();
    cout << "--------\n";
    graph.removeNode(0);
    graph.displayNodeList();
    cout << "--------\n";
}