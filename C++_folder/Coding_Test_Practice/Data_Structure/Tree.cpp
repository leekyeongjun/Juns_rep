#include <iostream>
using namespace std;

template <typename T>
class Node
{
    private:
    T value;
    Node* left;
    Node* right;
    Node* root;

    public:
    Node() : value(0), left(nullptr), right(nullptr), root(nullptr) {};
    Node(T _value) : value(_value), right(nullptr), root(nullptr) {};
    Node(T _value, Node* _left, Node* _right): value(_value), left(_left), right(_right), root(nullptr)
    {
        if(nullptr != _left)
            _left->root = this;
        if(nullptr != _right)
            _right->root = this;
    };
    ~Node(){};

    void SetLeft(Node* node){this->left = node;}
    void SetRight(Node* node){this->right = node;}
    Node* GetLeft(){return left;}
    Node* GetRight() {return right;}

    T GetValue() {return value;}
};

template <typename T>
void Preorder(Node<T>* node)
{
    if(node == nullptr)
        return;
    cout << node -> GetValue() << " ";
    Preorder(node->GetLeft());
    Preorder(node->GetRight());
}

template <typename T>
void Inorder(node<T>* node)
{
    if(node == nullptr)
        return;
    Inorder(node->GetLeft());
    cout << node -> GetValue() << " ";
    Inorder(node->GetRight());
}
template <typename T>
void Postorder(Node<T>* node) 
{ 
    if (node == nullptr)
        return;
    Postorder(node->GetLeft());
    Postorder(node->GetRight());
    cout << node->GetValue()<< " ";
}
