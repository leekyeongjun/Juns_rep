#include <iostream>

using namespace std;

class Node{
	int data;
	Node *link;

    public:
    void SetData(int d){data = d;}
    void SetLink(Node *l){link -> l;}
    int GetData(){return data;}
    Node * GetLink(){return link;}
};


int main(){

    Node* header = new Node();

    }
