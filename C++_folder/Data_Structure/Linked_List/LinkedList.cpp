#include <stdio.h>

typedef struct node{
	char *data;
	struct node *next;

}Node;

Node *head = NULL;

//=========================add=====================================
void add_first(char *item){
	Node *temp = new Node;
	temp -> data = item;
	temp -> next = head;
	head = temp;

	// if head is global variable, this can be available.
	// usage : add_first(item_to_store);
}

void add_first_local_variable(Node **ptr_head, char *item)
{
	Node *temp = new Node;
	temp -> data = item;
	temp -> next = *ptr_head;
	*ptr_head = temp;

	//usage : add_first_local_variable(&head, item_to_store);
}

Node * add_first_with_returning_address(Node *head, char* item)
{
	Node *temp = new Node;
	temp -> data = item;
	temp -> next = head;
	return temp;

	//usage : head = add_first_with_returning_address(head, item_to_store);
}

void add_after(Node * prev, char *item)
{
	if(prev != NULL)
	{
		Node *tmp = new Node;
		tmp -> data = item;
		tmp -> next = prev->next;
		prev -> next = tmp;
	}

	//usage : add_after(prev_node, item_to_add);
}


Node *get_node(int index){
	if(index <0)
		return NULL;
	Node *p = head;
	for(int i = 0; i<index && p != NULL; i++){
		p = p->next;
	}
	return p;
}

int add(int index, char *item){
	if(index <0)
		return 0;

	if(index == 0){
		add_first(item);
		return 1;
	}

	Node *prev = get_node(index-1);
	if(prev != NULL){
		add_after(prev, item);
		return 1;
	}
	return 0;

}

void add_to_ordered_list(char *item){
	Node *p = head;
	Node *q = NULL;

	while(p != NULL && strcmp(p->data, item)<= 0){
		q = p;
		p = p->next;
	}

	if(q == NULL)
		add_first(item);
	else
		add_after(q, item);
}

//============================remove============
Node * remove_first(){
	if(head == NULL){
		return NULL;
	}
	else
	{
		Node * tmp = head;
		head = head -> next;
		return tmp;
	} 
}



Node * remove_after(Node *prev){
	Node *tmp = prev->next;
	
	if(tmp == NULL){
		return NULL;
	}
	else{
		prev->next = tmp ->next;
		return tmp;
	}
}


Node *remove(int index){
	if(index < 0){
		return NULL;
	}
	if(index ==0){
		return remove_first();
	}

	Node *prev = get_node(index-1);
	if(prev==NULL)
		return NULL;
	else{
		return remove_after(prev);
	}
}

Node * remove(char * item){
	Node *p = head;
	Node *q = NULL;

	while(p !=NULL && strcmp(p->data, item)!= 0){
		q = p;
		p = p ->next;
	}

	if(p==NULL)
		return NULL;
	if(q==NULL)
		return remove_first();
	else
		return remove_after(q);
}

//===========================traverse==========
Node *find(char *word){
	Node *p = head;
	while(p!= NULL){
		if(strcmp(p->data, word)==0){
			return p;
		}
		p = p->next;
		//traverse
	}
	return NULL;
}

int main(){
	/*
	head = new Node;
	haed -> data = "Tuesday";
	head -> next = NULL;

	Node *q = new Node;
	q-> data = "Thursday";
	q-> next = NULL;
	head -> next = q;

	q = new Node;
	q-> data = "Monday";
	q-> next = head;
	head = q;

	Node *p = head;
	while (P!=NULL){
		printf("%s\n", p->data);
		p = p->next;
	}
	*/

	

}

