#ifndef LOGIC_H
#define LOGIC_H

#include <string>
#include <vector>
#include <unordered_map>


/*
Todos (Some Quality of life, some important like verifier):
    Make null pointers optionals + pattern matching in C++26 hopefully
    Add errors or a checker at end to make sure SExpression is valid
    ^^^^ Maybe or don't because speed over correctness amiright or amiright

    ^^^^For this program you can add error checking to the Lexer since there are 
        very few states (Looking for variable/negate) (Looking for Operator) (Done)

    Maybe change everything to official objects instead of structs to make godot happy ???????????
    Add a helper function to convert all logic symbols or words to specific numbers, would allow for more expressive formulas
    ^^^^If this is done, switch the entire thing over to u8strings and add converter method for weird godot strings

    Use function composition to make the parsing functions much more compact
    Add a verifier function to be called when enter is hit before assigning data to graphs 

    Would be fun to play around with alternate orders of operations in a game to see what
    life would be like with a different set of rules (Especially if Predicates and english sentences were added which would be easy for the parser)

    Should add an option like s/ to signify expression is already in the right format and we just need to verify
    This would be a great addition to slatecore as it fits in to that set of tools :)
*/




enum class Type {
    NEGATE,
    AND,
    OR,
    IF,
    IFF,
    LEFTPAREN,
    RIGHTPAREN,
    VARIABLE,
    None,
};

std::unordered_map<char32_t, Type> toType {
    {U'¬', Type::NEGATE},
    {U'∧', Type::AND},
    {U'∨', Type::OR},
    {U'→', Type::IF},
    {U'↔', Type::IFF},
    {U'(', Type::LEFTPAREN},
    {U')',Type::RIGHTPAREN},
};

struct Token {
    Type type;
    std::u32string value;
};
struct LogicNode {
    Type type = Type::None;
    LogicNode* left = nullptr;
    LogicNode* right = nullptr;
    std::u32string value = U"";
};

std::u32string toSExpression(LogicNode* head);
LogicNode* parseVariable(const std::vector<Token>& tokens);
LogicNode* parseExpression(const std::vector<Token>& tokens);
LogicNode* parseAND(const std::vector<Token>& tokens);
LogicNode* parseOR(const std::vector<Token>& tokens);
LogicNode* parseNot(const std::vector<Token>& tokens);
LogicNode* parseIF(const std::vector<Token>& tokens);
LogicNode* parseIFF(const std::vector<Token>& tokens);
LogicNode* u32stringToSExpression(std::u32string formula);
std::u32string getu32SExpression(const std::u32string formula);
std::string getu8SExpression(std::u32string formula);

#endif