//#pragma warning(disable:4996)

#define BUFFSIZE 1024
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


typedef struct polyTerm {
    int order;
    int coeff;
    struct polyTerm* nextNode;

}polyTerm;


typedef struct poly {
    polyTerm headNode;
} poly;

void clearPoly(poly* A) {
    polyTerm* delTerm = A->headNode.nextNode;
    polyTerm* tmpTerm = NULL;
     
    if(delTerm == NULL){
        printf("애초에 비어있는 식입니다. 제거 과정을 마칩니다.");
    }
    else{
        while(delTerm != NULL){
            tmpTerm = delTerm;
            delTerm = delTerm->nextNode;
            free(tmpTerm);
        }
        //printf("메모리 해제 완료.\n");
    }
}

poly createPoly(){
    poly p;
    p.headNode.nextNode = NULL;
    p.headNode.order = 0;
    p.headNode.coeff = 0;

    return p;
}


void printPoly_impl(poly A, char* buffer) {

    polyTerm *curTerm = A.headNode.nextNode;
    if(curTerm == NULL){
        buffer[0] = '0';
        return;
    }
    else{
        char c[10];
        sprintf(c, "%d", curTerm->coeff);
        char o[10];
        sprintf(o, "%d", curTerm->order);

        strcat(buffer, c);
        strcat(buffer, "x^");
        strcat(buffer, o);
        curTerm = curTerm->nextNode;

        while(curTerm != NULL && curTerm->coeff != 0){
            if(curTerm -> coeff > 0){
                strcat(buffer, "+");
            }
            char _c[10];
            sprintf(_c, "%d", curTerm->coeff);
            char _o[10];
            sprintf(_o, "%d", curTerm->order);
            strcat(buffer, _c);
            strcat(buffer, "x^");
            strcat(buffer, _o);

            curTerm = curTerm -> nextNode;
        }
    }
}


void printPoly(poly A) {
	char buffer[BUFFSIZE] = "";
	printPoly_impl(A, buffer);
	printf("%s",buffer);
}

void addTerm(poly* A, int exp, int coeff) {
    polyTerm* preTerm = NULL;
    polyTerm* curTerm = A->headNode.nextNode;
    polyTerm* newTerm = (polyTerm*)malloc(sizeof(polyTerm));
    
    if(coeff == 0){
        //printf("계수가 0인 항은 취급할 수 없습니다. 추가하지 않습니다.\n");
        return;
    }
    else{
        //printf("[%dx^%d 항에 대해 추가 작업 진행중 ...] \n", coeff, exp);
    }
    
    newTerm-> order = exp;
    newTerm-> coeff = coeff;
    newTerm-> nextNode = NULL;

    while(curTerm != NULL){
        if(curTerm-> order == newTerm->order){
            //printf("동일한 차수의 항이 있습니다. %d와 %d를 더해 %d차수의 하나의 항으로 취급합니다.\n", curTerm->coeff, newTerm->coeff, curTerm->order);
            curTerm->coeff += newTerm -> coeff;
            free(newTerm);
            //printf("=======================================================\n");
            return;
        }
        if(curTerm -> order < newTerm -> order){
            //printf("추가하고자 하는 항의 차수가 현재 위치 항의 차수보다 큽니다. 삽입 위치를 발견하여 탐색을 종료합니다.\n");
            break;
        }
        preTerm = curTerm;
        curTerm = curTerm->nextNode;
    }

    if(curTerm == NULL && preTerm == NULL){
        //printf("식에 항이 없으므로 첫번째 항으로 취급합니다.\n");
        A->headNode.nextNode = newTerm;
    }
    else if(curTerm != NULL && preTerm == NULL){
        //printf("식의 첫번째 항이 변경되어야 합니다. 변경합니다.\n");
        A->headNode.nextNode = newTerm;
        newTerm -> nextNode = curTerm;
    }
    else{
        //printf("식의 안에 첫번째가 아닌 위치에 새로운 항을 추가합니다.\n");
        newTerm->nextNode = preTerm->nextNode;
        preTerm->nextNode = newTerm;
    }

    //printf("=======================================================\n");
}

poly multiPoly(poly A, poly B) {
    poly C = createPoly();

    if(A.headNode.nextNode != NULL || B.headNode.nextNode != NULL){
        polyTerm* A_curterm = A.headNode.nextNode;
        while(A_curterm != NULL){
            polyTerm* B_curterm = B.headNode.nextNode;
            while(B_curterm != NULL){
                addTerm(&C, (A_curterm->order + B_curterm->order), (int)(A_curterm->coeff * B_curterm->coeff));
                B_curterm = B_curterm->nextNode;
            }
            A_curterm = A_curterm->nextNode;
        }
    }

    return C;
    
}



int main() {
	poly A, B, C;
    A = createPoly();
    B = createPoly();
    C = createPoly();

    addTerm(&A, 1, 1);
    addTerm(&A, 0, 1);
    printf("poly A: ");
    printPoly(A);
    printf("\n");

    addTerm(&B, 1, 1);
    addTerm(&B, 0, -1);
    printf("poly B: ");
    printPoly(B);
    printf("\n");

    printf("A*B: ");
    C = multiPoly(A,B);
    printPoly(C);
    printf("\n");

    clearPoly(&A);
    clearPoly(&B);
    clearPoly(&C);
	return 0;
}