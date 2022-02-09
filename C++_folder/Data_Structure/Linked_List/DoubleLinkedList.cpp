#include <stdio.h>

typedef struct node{
	char *data;
	struct node * next;
	struct node * prev;
}Node;

Node *head;
Node *tail;

int size = 0;

void add_after(Node *pre, char *item){
	Node *new_node = new Node;
	new_node->data = item;
	new_node->prev = NULL;
	new_node->next = NULL;
	
	//no nodes
	if(pre == NULL && head == NULL){
		head = new_node;
		tail = new_node;
	}
	
	//at the first
	else if(pre == NULL){
		new_node -> next = head;
		head -> prev = new_node;
		head = new_node;
	}
	//at the last
	else if(pre == tail){
		new_node -> prev = tail;
		tail->next = new_node;
		tail = new_node;
	}
	//at the middle
	else{
		new_node-> prev = pre;
		new_node-> next = pre->next;
		pre->next->prev = new_node;
		pre->next = new_node;
	}

	size++;
}

void revove_node(Node *p){
	// only one Node
	if(p->prev == NULL && p->next ==NULL){
		head = NULL;
		tail = NULL;
		delete p;
	}

	//removing Head node
	else if(p->prev == NULL){
		head = p->next;
		p->next->prev = NULL;
		delete p;
	}

	//removing tail node
	else if(p->next == NULL){
		tail = p->prev;
		p->prev->next = NULL;
		delete p;
	}

	//generic
	else {
		p->next->prev = p->prev;
		p->prev->next = p->next;
		delete p;
	}

}
int main()
{
}
