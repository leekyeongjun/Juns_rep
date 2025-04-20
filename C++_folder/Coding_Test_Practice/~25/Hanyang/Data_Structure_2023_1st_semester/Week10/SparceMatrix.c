#include <stdio.h>
#include <stdlib.h>

typedef struct matrixNode* matrixPointer;
typedef struct entryNode{
    int row;
    int col;
    int value;
}entryNode;

typedef struct matrixNode
{
    matrixPointer down;
    matrixPointer right;
    union u{
        matrixPointer next;
        entryNode entry;
    } u;
}matrixNode;

void initMatrix(matrixPointer pMatrix, int row, int col){
    int headSize ,i;
    matrixPointer pTmpNode, pHeadNode;
    pMatrix->down = NULL;
    pMatrix->right = NULL;
    pMatrix->u.entry.row = row;
    pMatrix->u.entry.col = col;
    pMatrix->u.entry.value = 0;

    pTmpNode = pMatrix;
    if(row > col) headSize = row;
    else headSize = col;
    for(i = 0; i<headSize; i++){
        pHeadNode = (matrixPointer)malloc(sizeof(matrixNode));
        pHeadNode -> down = NULL;
        pHeadNode -> right = NULL;
        pHeadNode -> u.next = NULL;
        if(i == 0) pTmpNode -> right = pHeadNode;
        else pTmpNode -> u.next = pHeadNode;
        pTmpNode = pHeadNode;
    }
}

void addElement(matrixPointer pMatrix, int row, int col, int value){
    int i, j;
    matrixPointer pRightNode, pDownNode, pNewNode, pTmpNode;
    if(pMatrix->u.entry.row -1 < row || pMatrix-> u.entry.col - 1 < col){
        printf("matrix capacity over");
        return;
    }

    pNewNode = (matrixPointer)malloc(sizeof(matrixNode));
    pNewNode -> down = NULL;
    pNewNode -> right = NULL;
    pNewNode -> u.entry.row = row;
    pNewNode -> u.entry.col = col;
    pNewNode -> u.entry.value = value;

    pRightNode = pMatrix -> right;
    pDownNode  = pMatrix -> right;
    for(i = 0; i<row; i++){
        pRightNode = pRightNode-> u.next;
    }
    for(j = 0; j<col; j++){
        pDownNode = pDownNode -> down;
    }
    while(pRightNode -> right != NULL && pRightNode->right->u.entry.col < col){
        pRightNode = pRightNode -> right;
    }
    while(pDownNode -> down != NULL && pDownNode -> down -> u.entry.row < row){
        pDownNode = pDownNode-> down;
    }

    pTmpNode = pRightNode -> right;
    pRightNode-> right = pNewNode;
    pNewNode->right = pTmpNode;

    pTmpNode = pDownNode -> right;
    pDownNode-> right = pNewNode;
    pNewNode->right = pTmpNode;

    pMatrix->u.entry.value++;
}
void printMatrix(matrixNode matrix){
    int i,j,tmp,pos = 0;
    matrixPointer pTmpNode, pPrintNode;

    if(matrix.right == NULL){
        printf("Enpty\n");
        return;
    }

    pTmpNode = matrix.right;
    for(i = 0; i<matrix.u.entry.row; i++){
        if(pTmpNode -> right != NULL){
            pPrintNode = pTmpNode->right;
            while(pPrintNode != 0){
                tmp = pPrintNode->u.entry.col - pos;
                for(j = 0; j<tmp; j++, pos++)
                    printf(" 0");
                printf("%2d", pPrintNode->u.entry.value);
                pos++;
            }
        }
        for(j = pos; j<matrix.u.entry.col; j++) printf(" 0");
        printf("\n");
        pTmpNode = pTmpNode->u.next;
        pos = 0;
    }
    printf("\n");
}
void transpose(matrixPointer pMatrix){
    matrixPointer pTmpNode, pSearchNode;
    if(pMatrix->right == NULL){
        printf("Empty matrix\n");
        return;
    }
    swap(&pMatrix->u.entry.col, &pMatrix->u.entry.row);
    pTmpNode = pMatrix->right;
    while(pTmpNode != NULL){
        swapPointer(&pTmpNode->right, &pTmpNode->down);
        pSearchNode = pTmpNode->down;

        while(pSearchNode != NULL){
            swapPointer(&pSearchNode -> right, &pSearchNode -> down);
            swap(&pSearchNode -> u.entry.col, &pSearchNode->u.entry.row);
            pSearchNode = pSearchNode->down;
        }
        pTmpNode = pTmpNode->u.next;
    }
}


matrixNode matMul (matrixPointer pLeftMatrix, matrixPointer pRightMatrix) {
    int row = pLeftMatrix->u.entry.row, col = pRightMatrix->u.entry.col, x = 0, y = 0; 
    matrixNode resultMatrix;
    matrixPointer pLeftNode, pRightNode, pLeftTmpNode, pRightTmpNode;
    // 곱셈 결과 저장을 위한 행렬 초기화
    initMatrix (&resultMatrix, row, col); 
    pLeftNode = pLeftMatrix->right; 
    pRightNode = pRightMatrix->right;
    // 왼쪽 행렬 기준 탐색
    while (pLeftNode != NULL) {
        if (pLeftNode->right != NULL) { 
            pLeftTmpNode = pLeftNode->right;
            while (pLeftTmpNode != NULL) {
            // 오른쪽 행렬 기준 탐색
                while (pRightNode != NULL) {
                    if (pRightNode->down != NULL) {
                        pRightTmpNode = pRightNode->down;
                        while (pRightTmpNode != NULL) {
                        // 왼쪽 행렬의 행과 오른쪽 행렬의 열이 곱셈이 가능한지 확인 
                            if (pLeftTmpNode->u.entry.row == pRightTmpNode->u.entry.col && pLeftTmpNode->u.entry.col == pRightTmpNode->u.entry.row){
                                addElement(&resultMatrix, x, y, pLeftTmpNode->u.entry.value* pRightTmpNode->u.entry.value);
                            }
                            pRightTmpNode = pRightTmpNode->down;
                        }
                    }
                    y++;
                    pRightNode = pRightNode->u.next;
                }
                pLeftTmpNode = pLeftTmpNode->right;
            }
        }   
        x++; y = 0;
        pLeftNode = pLeftNode->u.next;
        pRightNode = pRightMatrix->right;
    }
    return resultMatrix;
}

void swap(int* x, int* y){
    int tmp;
    tmp = *x;
    *x = *y;
    *y = tmp;
}

void swapPointer(matrixPointer* x, matrixPointer *y){
    matrixPointer tmp;
    tmp = *x;
    *x = *y;
    *y = tmp;
}

int main(){

}