#include "logic.hpp"
#include <iostream>
#include <codecvt>
#include <locale>

int myIndex = 0;
LogicNode* parseVariable(const std::vector<Token>& tokens) {
    Type curr = tokens[myIndex].type;
    myIndex++;
    switch (curr) { 
        case Type::LEFTPAREN: {
            LogicNode* node = parseExpression(tokens);
            return node;
        }
        case Type::NEGATE: {
            LogicNode* node = parseNot(tokens);
            return node;
        }
        case Type::VARIABLE: {
            LogicNode* node = new LogicNode();
            node->type = Type::VARIABLE;
            node->value = tokens[myIndex - 1].value;
            return node;
        }
    }
    return nullptr;
}

LogicNode* parseIFF(const std::vector<Token>& tokens) {
    LogicNode* left = parseIF(tokens);
    while(1) {
        if (myIndex >= tokens.size() || tokens[myIndex].type != Type::IFF) {
            break;
        } 
        myIndex++;
        LogicNode* temp = new LogicNode();
        temp->left = left;
        left = temp;
        left->type = Type::IFF;
        left->right = parseIF(tokens);
    }
    if(left->type == Type::None) {
        return left->left;
    }
    return left;
}

LogicNode* parseIF(const std::vector<Token>& tokens) {
    LogicNode* left = parseOR(tokens);
    while(1) {
        if (myIndex >= tokens.size() || tokens[myIndex].type != Type::IF) {
            break;
        } 
        myIndex++;
        LogicNode* temp = new LogicNode();
        temp->left = left;
        left = temp;
        left->type = Type::IF;
        left->right = parseOR(tokens);
    }
    if(left->type == Type::None) {
        return left->left;
    }
    return left;
}

LogicNode* parseOR(const std::vector<Token>& tokens) {
    LogicNode* left = parseAND(tokens);
    while(1) {
        if (myIndex >= tokens.size() || tokens[myIndex].type != Type::OR) {
            break;
        } 
        myIndex++;
        LogicNode* temp = new LogicNode();
        temp->left = left;
        left = temp;
        left->type = Type::IFF;
        left->right = parseOR(tokens);
    }
    if(left->type == Type::None) {
        return left->left;
    }
    return left;
}

LogicNode* parseAND(const std::vector<Token>& tokens) {
    LogicNode* left = parseVariable(tokens);
    while(1) {
        if (myIndex >= tokens.size() || tokens[myIndex].type != Type::AND) {
            break;
        } 
        myIndex++;
        LogicNode* temp = new LogicNode();
        temp->left = left;
        left = temp;
        left->type = Type::AND;
        left->right = parseVariable(tokens);
    }
    if(left->type == Type::None) {
        return left->left;
    }
    return left;
}

LogicNode* parseNot(const std::vector<Token>& tokens) {
    LogicNode* node = new LogicNode();
    node->left = parseVariable(tokens);
    node->type = Type::NEGATE;
    return node;
}

LogicNode* parseExpression(const std::vector<Token>& tokens) {
    if(tokens[myIndex].type == Type::RIGHTPAREN) {
        return nullptr;
    }
    LogicNode* left = parseIFF(tokens);
    while(myIndex < tokens.size()) {
        if(tokens[myIndex].type == Type::RIGHTPAREN) {
            return left;
        }
        Type type = tokens[myIndex++].type;
        LogicNode* temp = new LogicNode();
        temp->left = left;
        temp->type = type;
        temp->right = parseIFF(tokens);
        left = temp;
    }
    return left;
}


/*
    THIS FUNCTION IS NEEDED BECAUSE ENUMS ARE NOT HASHABLE IN GODOT HASHMAPS
    If this function isn't moved back to godot it can be changed to a map, otherwise it could be a switch in godot
*/
std::u32string getType(Type type) {
    if(type == Type::NEGATE)  {
        return U"NEGATE";
    }
    if(type == Type::AND) {
        return U"AND";
    }
    if(type == Type::OR) {
        return U"OR";
    }
    if(type == Type::IF) {
        return U"IF";
    }
    if(type == Type::IFF) {
        return U"IFF";
    } 
    if(type == Type::VARIABLE) {
        return U"Identifier";
    }
    if(type == Type::LEFTPAREN) {
        return U"(";
    } 
    if(type == Type::RIGHTPAREN) {
        return U")";
    }
    return U"";
}

/*
    Lexes and parses logical expression, converting them to a AST 
*/
LogicNode* u32stringToSExpression(std::u32string formula) {
    myIndex = 0;
    std::vector<Token> tokens;
    int myIndex = 0;
    int stringCount = 0;
    while(myIndex < formula.length()) {
        if(toType.find(formula[myIndex]) != toType.end()) {
            if(stringCount != 0) {
                tokens.push_back({Type::VARIABLE, formula.substr(myIndex - stringCount, stringCount)});
                stringCount = 0;
            }
            tokens.push_back({toType[formula[myIndex]], U""});
        } else {
            if(stringCount != 0 && formula[myIndex] == U' ') {
                tokens.push_back({Type::VARIABLE, formula.substr(myIndex - stringCount, stringCount)});
                stringCount = 0;
            } else {
                if(formula[myIndex] != U' ') {
                    stringCount++;
                }
            }
        }
        if(stringCount != 0 && myIndex == formula.length() - 1) {
            tokens.push_back({Type::VARIABLE, formula.substr(myIndex + 1 - stringCount, stringCount)});
        }
        myIndex++;
    }
    LogicNode* head = parseExpression(tokens);
    return head;
}

/*
    Prints AST in prefix order like the expression was written
*/
void printer(LogicNode* head) {
    std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> converter;
    if(head->left == nullptr && head->right == nullptr) {
        std::cout << converter.to_bytes(getType(head->type)) << " Value: " << converter.to_bytes(head->value) << '\n';
    } else {
        if(head->left != nullptr) {
            printer(head->left);
        } 
        std::cout << converter.to_bytes(getType(head->type)) << " Value: " << converter.to_bytes(head->value) << '\n';
        if(head->right != nullptr) {
            printer(head->right);
        }
    }
}

/*
    Converts AST to SExpression
    Could do checking here 
*/
std::u32string toSExpression(LogicNode* head) {
    if(head->type == Type::VARIABLE) {
        return head->value;
    } else if(head->type == Type::NEGATE) {
        if(head->left == nullptr) {
            return U"";
        }
        return U"(not " + toSExpression(head->left) + U")";
    } else {
        if(head->type == Type::None || head->left == nullptr || head->right == nullptr) {
            return U"";
        }
        return U"(" + getType(head->type) + U" " + toSExpression(head->left) + U" " + toSExpression(head->right) + U")";
    }
}

std::u32string getu32SExpression(std::u32string formula) {
    LogicNode* head = u32stringToSExpression(formula);
    return toSExpression(head);
}

std::string getu8SExpression(std::u32string formula) {
    std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> conv;
    return conv.to_bytes(getu32SExpression(formula));
}

/*
Just a little test if you want to play around with it
*/
int main() {
    std::u32string formula = U"B→¬(A∧C)";
    std::cout << getu8SExpression(formula);
}


