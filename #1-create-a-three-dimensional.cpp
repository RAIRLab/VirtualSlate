#include <iostream>
#include <vector>
#include <algorithm>

// Define a class for nodes in the graph
class Node {
public:
    int data;
    std::vector<Node*> neighbors;

    Node(int val) : data(val) {}
};

// Define a class for the 3D graph
class ProofGraph {
public:

    std::vector<std::vector<std::vector<Node*>>> graph;

    ProofGraph(int x, int y, int z) {
        graph.resize(x, std::vector<std::vector<Node*>>(y, std::vector<Node*>(z, nullptr)));
    }

    void addNode(int x, int y, int z, int data) {
        if (x >= 0 && x < graph.size() && y >= 0 && y < graph[0].size() && z >= 0 && z < graph[0][0].size()) {
            Node* newNode = new Node(data);
            graph[x][y][z] = newNode;
        }
    }

    void addEdge(int x1, int y1, int z1, int x2, int y2, int z2) {
        if (isValidPosition(x1, y1, z1) && isValidPosition(x2, y2, z2)) {
            Node* node1 = graph[x1][y1][z1];
            Node* node2 = graph[x2][y2][z2];
            if (node1 && node2) {
                node1->neighbors.push_back(node2);
            }
        }
    }

    void removeNode(int x, int y, int z) {
        // Remove the node from the graph
        if (isValidPosition(x, y, z) && graph[x][y][z]) {
            Node* nodeToRemove = graph[x][y][z];

            // Remove all edges connected to the node
            for (int i = 0; i < graph.size(); ++i) {
                for (int j = 0; j < graph[0].size(); ++j) {
                    for (int k = 0; k < graph[0][0].size(); ++k) {
                        if (graph[i][j][k]) {
                            graph[i][j][k]->neighbors.erase(
                                std::remove(graph[i][j][k]->neighbors.begin(), graph[i][j][k]->neighbors.end(), nodeToRemove),
                                graph[i][j][k]->neighbors.end()
                            );
                        }
                    }
                }
            }

            // Delete the node and set the pointer to a null pointer
            delete nodeToRemove;
            graph[x][y][z] = nullptr;
        }
    }

    bool isValidPosition(int x, int y, int z) {
        return x >= 0 && x < graph.size() && y >= 0 && y < graph[0].size() && z >= 0 && z < graph[0][0].size();
    }
};

int main() {
    // Create a 3D proof graph with dimensions 5x5x5
    ProofGraph proofGraph(5, 5, 5);

    // Add nodes to the graph
    proofGraph.addNode(0, 0, 0, 1);
    proofGraph.addNode(0, 1, 0, 2);
    proofGraph.addNode(1, 0, 0, 3);
    proofGraph.addNode(1, 1, 0, 4);

    // Add edges between nodes
    proofGraph.addEdge(0, 0, 0, 0, 1, 0);
    proofGraph.addEdge(0, 0, 0, 1, 0, 0);
    proofGraph.addEdge(0, 1, 0, 1, 1, 0);

    // Remove a node and its edges
    proofGraph.removeNode(0, 0, 0);

    return 0;
}