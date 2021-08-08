#include <iostream>
#include <vector>

using namespace std;

class Node{
    char data;
    Node* child;
    Node* sibling;

    public:
    Node(){data=""; child= NULL; sibling=NULL;}
    Node(char s){data=s; child=NULL; sibling=NULL;}

    void SetData(char n){this -> data = n;}
    void SetSibling(Node* node){this -> sibling = node;}
    void SetChild(Node* node){this -> child = node;}

    char GetData(){return this -> data;}
    Node* GetSibling(){return this ->sibling;}
    Node* GetChild(){return this->child;}
};




void Show_headFirst(Node* node){
    if(node == NULL){
        cout << "";
    }
    else{
        if(node->GetData() != '.')
        {
            cout << node->GetData();
        }
        Show_headFirst(node->GetChild());
        Show_headFirst(node->GetSibling());
    } 
}

void Show_midFirst(Node* node){
    if(node == NULL){
        cout << "";
    }
    else{
        Show_headFirst(node->GetChild());
        if((node->GetData()) != '.')
        {
            cout << node->GetData();
        }
        Show_headFirst(node->GetSibling());
    } 
}
void Show_tailFirst(Node* node){
    if(node == NULL){
        cout << "";
    }
    else{
        Show_headFirst(node->GetChild());
        Show_headFirst(node->GetSibling());
        if(node->GetData() != '.')
        {
            cout << node->GetData();
        }
    } 
}

int main()
{
    int n, dg;
    cin >>n;
    Node rootNode;
    Node* Nodes = new Node[n];
    while(n >0)
    {
        char a, b, c;
        cin >> a;
        if(a!='.')
            Nodes[(int)(a-'A')].SetData(a);
        if (b != '.')
            Nodes[(int)(a - 'A')].SetChild(&a[(int)(b - 'A')]);
        else
            Nodes[(int)(a - 'A')].SetChild(NULL);
        if (right != '.')
            Nodes[(int)(a - 'A')].SetSibling(&Nodes[(int)(c - 'A')]);
        else
            Nodes[(int)(a - 'A')].SetSibling(NULL);
        


    }
    Node *root = &Nodes[0];
    Show_headFirst(root);
    Show_midFirst(root);
    Show_tailFirst(root);
}