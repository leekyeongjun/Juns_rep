#include <iostream>

using namespace std;

class Node{
    int data;
    Node* child;
    Node* sibling;
    Node* root;

    public:
    Node(){data = 0; child= NULL; sibling=NULL; root=NULL;}
    Node(int d){data=d; child=NULL; sibling=NULL; root=NULL;}

    void SetData(int n){this -> data = n;}
    void SetSibling(Node* node){this -> sibling = node;}
    void SetChild(Node* node){this -> child = node;}
    int GetData(){return this -> data;}
    Node* GetSibling(){return this ->sibling;}
    Node* GetChild(){return this->child;}
};

void Show_headFirst(Node* node){
    if(node == NULL){
        cout << endl;
    }
    else{
        cout << node->GetData() << " ";
        Show_headFirst(node->GetChild());
        Show_headFirst(node->GetSibling());
    } 
}


int main(){
    Node* firstNode = new Node();
    Node* secondNode = new Node();
    Node* thirdNode = new Node();

    Node* newNode = new Node();
    Node* newNode_2 = new Node();

    firstNode->SetData(3);
    secondNode->SetData(2);
    thirdNode->SetData(1);
    newNode->SetData(4);
    newNode_2->SetData(7);

    firstNode->SetChild(secondNode);
    secondNode->SetSibling(thirdNode);
    thirdNode->SetSibling(newNode);
    newNode->SetChild(newNode_2);

    Show_headFirst(firstNode);

    delete newNode;
    delete newNode_2;
    delete firstNode;
    delete secondNode;
    delete thirdNode;
}