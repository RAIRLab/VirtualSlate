#include <gtest/gtest.h>
#include "graph.cpp"
#include <iostream>
#include <map>
#include <tuple>

TEST(GraphAddNode, BasicAssertions) {
    ProofGraph graph = ProofGraph();
    for(int i = 0; i < 50; i++) {
        graph.addNode(std::make_tuple(i, i + 1, i + 2), i);
    }
    auto currGraph = graph.getNodeMap();
    for(int i = 49; i > -1; i-- ) {
        Node* curr = &currGraph[i];
        EXPECT_EQ(curr->nodeID, i);
        EXPECT_EQ(std::get<0>(curr->location), i);
        EXPECT_EQ(std::get<1>(curr->location), i + 1);
        EXPECT_EQ(std::get<2>(curr->location), i + 2);
    }
    EXPECT_EQ(graph.getSize(), 50);
}


TEST(GraphRemoveNodeWithoutEdges, BasicAssertions) {
    ProofGraph graph = ProofGraph();
    ProofGraph answer = ProofGraph();
    graph.removeNode(0);
    EXPECT_EQ((graph.getNodeMap()).size(), 0);
    graph.addNode(std::make_tuple(0,0,0), 0);
    graph.removeNode(0);
    EXPECT_EQ((graph.getNodeMap()).size(), 0);

    graph = ProofGraph();
    for(int i = 0; i < 50; i++) {
        answer.addNode(std::make_tuple(i, i + 1, i + 2), i);
        graph.addNode(std::make_tuple(i, i + 1, i + 2), i);
    }

    for(int i = 0; i < 50; i++) {
        if(i % 2 != 0) {
            graph.removeNode(i);
        }
    }

    auto graphNodes = graph.getNodeMap();
    auto answerNodes = answer.getNodeMap();

    for(int i = 0; i < 50; i++) {
        if(i % 2 == 0) {
            EXPECT_EQ(graphNodes.find(i) == graphNodes.end(), false);
            Node* answer = &answerNodes[i];
            Node* graphNode = &graphNodes[i];
            EXPECT_EQ(std::get<0>(answer->location), std::get<0>(graphNode->location));
            EXPECT_EQ(std::get<1>(answer->location), std::get<1>(graphNode->location));
            EXPECT_EQ(std::get<2>(answer->location), std::get<2>(graphNode->location));
        } else {
            EXPECT_EQ(graphNodes.find(i) == graphNodes.end(), true);            
        }
    }
    EXPECT_EQ(graphNodes.size(), 25);
}

TEST(GraphAddEdge, BasicAssertions) {
    ProofGraph graph = ProofGraph();
    for(int i = 0; i < 50; i++) {
        graph.addNode(std::make_tuple(i, i + 1, i + 2), i);
    }
    for(int i = 0; i < 50; i++) {
        if(i == 12) {
            continue;
        }
        graph.addEdge(12, i);
    }
    auto graphNodes = graph.getNodeMap();
    Node* twelve = &graphNodes[12];
    for(auto& curr : graphNodes) {
        if(&curr.second == twelve) {
            EXPECT_EQ(curr.second.neighbors.size(), 49);
        } else {
            EXPECT_EQ(curr.second.neighbors.size(), 1);
        }
    }
}

TEST(GraphRemoveNode, BasicAssertions) {
    ProofGraph graph = ProofGraph();
    ProofGraph answer = ProofGraph();
    for(int i = 0; i < 50; i++) {
        answer.addNode(std::make_tuple(i, i + 1, i + 2), i);
        graph.addNode(std::make_tuple(i, i + 1, i + 2), i);
    }
    for(int i = 0; i < 50; i++) {
        if(i == 12) {
            continue;
        }
        graph.addEdge(12, i);
    }
    graph.removeNode(12);
    answer.removeNode(12);
    EXPECT_EQ(answer.representation(), graph.representation());
}



