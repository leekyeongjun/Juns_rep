#include <stdlib.h>
#include <stdio.h>

#define TRUE 1
#define FALSE 0

typedef struct TBTNode{

    //if TRUE, child is predecessor. FALSE, childe is Successor.

    int leftFlag, rightFlag;
    TBTNode* leftChild;
    TBTNode* rightChild;
    int data;

}TBTNode;

TBTNode* getMostLeft(TBTNode* root){
    if(root == NULL) return NULL;
    else{
        while(root->leftChild != NULL && root->leftFlag == FALSE){
            root = root->leftChild;
        }
        return root;
    }
}

void getInSucc(TBTNode* root){

}
void insertTBT(TBTNode** root, int data){

}