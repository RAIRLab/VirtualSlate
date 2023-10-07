
#include<set>
#include<map>

#include "core/object/ref_counted.h"
#include "core/math/vector3.h"

struct ProofNode{
    int nodeID;
    // Placeholder for 3D location info as I'm not sure how Godot handles it
    Vector3 location;
    // Placeholder for formula data
    int data;
    // Potentially split into seperate parent/child sets?
    std::set<ProofNode*> neighbors;

    ProofNode();
    ProofNode(int nodeID, const Vector3& location, int data);
};

class ProofGraph : public RefCounted{
        GDCLASS(ProofGraph, RefCounted);
        int nodeCount;
        std::map<int, ProofNode> nodeMap;
    protected:
        static void _bind_methods();
    public:
        ProofGraph();
        void displayNodeList();
        void addNode(const Vector3& location, int data);
        void addEdge(int start, int end);
        void removeNode(int deleteID);
};