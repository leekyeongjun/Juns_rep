#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define FALSE -1
#define TRUE 1

typedef struct Node{
    int data;
    struct Node* nextnode;
}Node;

typedef struct  
{
    int curCount;
    Node headnode;
}LinkedList;

int addNode(LinkedList* pList, int pos, int data);
int removeNode(LinkedList* pList, int pos);
void showNode(LinkedList* pList);
int isEmpty(LinkedList* pList);
int findpos(LinkedList* pList, int data);
void makeEmpty(LinkedList* pList);

void showNode(LinkedList* pList){
    int i = 0 ;
    Node *pNode = NULL;

    if(pList == NULL){
        printf("ShowNode() Error \n");
        return;
    }

    printf("현재 노드 개수 : %d\n", pList -> curCount);
    pNode = pList->headnode.nextnode;

    while(pNode != NULL){
        printf("[%d]\n", pNode->data);
        pNode = pNode->nextnode;
    }
    printf("------------------\n");
}

int isEmpty(LinkedList *pList){
    if(pList == NULL){
        printf("isEmpty() Error!\n");
        return -1;
    }
    if(pList -> headnode.nextnode == NULL) return TRUE;
    else return FALSE;
}

int findpos(LinkedList* pList, int data){
    int pos = 0;
    Node *pNode = NULL;

    if(pList == NULL){
        printf("FindPos Error!\n");
        return FALSE;
    }
    pNode = pList->headnode.nextnode;
    while(pNode != NULL){
        if(pNode->data == data){
            return pos;
        }
        else{
            pos++;
            pNode = pNode->nextnode;
        }
    }
    return false;
}

void makeEmpty(LinkedList * pList){
    Node* pDummyNode = NULL, *pTmpNode = NULL;
    if(pList != NULL){
        pTmpNode = pList -> headnode.nextnode;
        while(pTmpNode != NULL){
            pDummyNode = pTmpNode;
            pTmpNode = pTmpNode->nextnode;
            free(pDummyNode);
        }
        pList -> headnode.nextnode = NULL;
        pList -> curCount = 0;
    }
}

int addNode(LinkedList * pList, int pos, int data){
    int i = 0;
    Node* pNewNode = NULL, *pTmpNode = NULL;
    if(pList == NULL){
        printf("addNode() Error_1\n");
        return FALSE;
    }
    if(pos < 0 || pos > pList -> curCount){
        printf("addNode() Error_2\n");
        return FALSE;
    }
    pNewNode = (Node*)malloc(sizeof(Node));
    if(!pNewNode){
        printf("addNode() Error_3\n");
        return FALSE;
    }

    pNewNode->data = data;
    pNewNode->nextnode = NULL;


    pTmpNode = &(pList->headnode);

    for(i = 0; i<pos; i++){
        pTmpNode = pTmpNode->nextnode;
    }

    pNewNode->nextnode = pTmpNode->nextnode;
    pTmpNode->nextnode = pNewNode;
    pList -> curCount++;
    return TRUE;
}
int removeNode(LinkedList *pList, int pos){
    int i = 0;
    Node* pDelNode = NULL, *pTmpNode = NULL;
    if(pList == NULL){
        printf("removeNode() Error_1\n");
        return FALSE;
    }
    if(pos < 0 || pos > pList->curCount){
        printf("removeNode() Error_2\n");
    }
    pTmpNode = &(pList->headnode);
    for(int i = 0; i<pos; i++){
        pTmpNode = pTmpNode->nextnode;
    }

    pDelNode = pTmpNode->nextnode;
    pTmpNode->nextnode = pDelNode->nextnode;
    free(pDelNode);
    pList->curCount--;
    return TRUE;
}

int main(){
    int pos;
    LinkedList* linkedlist = (LinkedList*)malloc(sizeof(LinkedList));
    linkedlist -> curCount = 0;
    linkedlist -> headnode.nextnode = NULL;

    showNode(linkedlist);
    addNode(linkedlist,0,10);
    addNode(linkedlist,5,100);
    addNode(linkedlist,1,20);
    addNode(linkedlist,2,30);
    addNode(linkedlist,1,50);

    showNode(linkedlist);

    removeNode(linkedlist,1);
    showNode(linkedlist);

    pos = findpos(linkedlist,50);
    printf("%d\n", pos);

    makeEmpty(linkedlist);
    showNode(linkedlist);
}