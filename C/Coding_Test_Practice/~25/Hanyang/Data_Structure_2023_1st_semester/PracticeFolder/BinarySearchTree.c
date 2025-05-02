#include <stdio.h>
#include <stdlib.h>

#define TRUE 1
#define FALSE 0

// Binary Search Tree Implementation

typedef struct TreeNode{
    int data;
    struct TreeNode* leftChild;
    struct TreeNode* rightChild;
}TreeNode;

void insertNode(TreeNode ** root, int d){
    // if root is Null
    if((*root) == NULL){
        (*root) = (TreeNode*)malloc(sizeof(TreeNode));
        (*root)->data = d;
        (*root)->leftChild = NULL;
        (*root)->rightChild = NULL;
    }
    else{
        if((*root)->data > d){
            insertNode(&((*root)->leftChild), d);
        }
        else if((*root)->data <d)
        {
            insertNode(&((*root)->rightChild), d);
        }
        else{
            //error
            return;
        }
    }
}

void printTreeInorder(TreeNode* pNode){
    if(pNode == NULL){
        return;
    }
    
    printTreeInorder(pNode->leftChild);
    printf("%3d", pNode->data);
    printTreeInorder(pNode->rightChild);
}

void search(TreeNode** root, int value){
    if((*root) == NULL){
        printf("Search End\n");
    }
    else if((*root)-> data == value){
        printf("%d Found!\n", value);
    }
    else{
        if((*root)->data > value){
            search(&((*root)->leftChild), value);
        }
        else {
            search(&((*root)->rightChild), value);
        }
    }
}

TreeNode* copyTree(TreeNode* origin){
    TreeNode* tmpTree = NULL;

    if(origin){
        tmpTree = (TreeNode*)(malloc)(sizeof(TreeNode));
        tmpTree->leftChild = copyTree(origin->leftChild);
        tmpTree->rightChild = copyTree(origin->rightChild);
        tmpTree->data = origin->data;
        return tmpTree;
    }
    return NULL;
}

int isEqual(TreeNode* a, TreeNode* b){
    if(!a && !b) return TRUE;
    else{
        if((a->data == b->data )&& isEqual(a->leftChild, b->leftChild) && isEqual(a->rightChild, b->rightChild)){
            return TRUE;
        }
        else return FALSE;
    }
}

int main(){
    TreeNode* BST = NULL;
    insertNode(&BST, 1);
    insertNode(&BST, 7);
    insertNode(&BST, 6);
    insertNode(&BST, 4);
    insertNode(&BST, 8);

    
    printTreeInorder(BST);
    printf("\n");

    
    TreeNode* CopiedTree = copyTree(BST);

    printTreeInorder(CopiedTree);
    printf("\n");
    
    if(isEqual(CopiedTree, BST) == TRUE) printf("Equal!\n");
    /*
    search(&BST, 7);
    search(&BST, 1);
    search(&BST, 14);
    */
    
}