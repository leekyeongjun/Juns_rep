#include <stdio.h>
#include <stdlib.h>

#define TRUE 1
#define FALSE 0

typedef struct StackNode
{
    int data;
    struct StackNode *next;
    
}StackNode;

void pushLinkedStack(StackNode** top, int data);
StackNode* popLinkedStack(StackNode** top);
void showLinkedStack(StackNode** top);
StackNode* topLinkedStack(StackNode* top);
void deleteLinkedStack(StackNode** top);
int isEmpty(StackNode* top);

int main(){
    StackNode* top = NULL;
    StackNode* pNode;

    printf("push 10, 20, 30\n");
    pushLinkedStack(&top, 10);
    pushLinkedStack(&top, 20);
    pushLinkedStack(&top, 30);
    showLinkedStack(top);

    printf("pop()\n");
    pNode = popLinkedStack(&top);
    if(pNode){
        free(pNode);
        showLinkedStack(top);
    }

    printf("top()\n");
    pNode = topLinkedStack(top);
    if(pNode){
        printf("The top is %d", pNode->data);
    } else printf("Empty.");

    deleteLinkedStack(&top);
    return 0;
}

int isEmpty(StackNode* top){
    if(top == NULL) return TRUE;
    else return FALSE;
}

void ShowLinkedStack(StackNode* top){
    StackNode *pNode = NULL;
    if(isEmpty(top)){
        printf("Empty\n");
        return;
    }
    pNode = top;
    printf("============================\n");
    while(pNode != NULL){
        printf("[%d]\n",pNode -> data);
        pNode = pNode->next;
    }
    printf("============================\n");
}

void pushLinkedStack(StackNode** top, int data){
    StackNode *pNode = NULL;
    pNode = (StackNode*)malloc(sizeof(StackNode));
    pNode -> data = data;
    pNode -> next = NULL;
    if(isEmpty(*top)) *top = pNode;
    else{
        pNode ->next = *top;
        *top = pNode;
    }
}

StackNode* popLinkedStack(StackNode** top){
    StackNode *pNode = NULL;
    if(isEmpty(*top)){
        printf("Empty\n");
        return NULL;
    }
    pNode = *top;
    *top = pNode -> next;
    return pNode;
}

StackNode * topLinkedStack(StackNode *top){
    StackNode *pNode = NULL;
    if(!isEmpty(top)) pNode = top;
    return pNode;
}

void deleteLinkedStack(StackNode** top){
    StackNode *pNode = NULL, *pDelNode = NULL;
    pNode = *top;

    while(pNode != NULL){
        pDelNode = pNode;
        pNode = pNode->next;
        free(pDelNode);
    }
    *top = NULL;
}
