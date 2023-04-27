#include <stdio.h>
#include <stdlib.h>

#define Capacity 5
#define TRUE 1
#define FALSE 0

typedef struct CircularQueue
{
    int data[Capacity];
    int front;
    int rear;
}cQueue;

cQueue* createCircularQueue();
void enqueue(cQueue* cQueue, int data);
int isFull(cQueue* cQueue);
void showQueue(cQueue* cQueue);
int isEmpty(cQueue* cQueue);
void dequeue(cQueue* cQueue);

int main(){
    cQueue* cQueue;
    cQueue = createCircularQueue();

    printf("front : %d, rear : %d\n", cQueue->front, cQueue->rear);

    printf("enqueue 10\n");
    enqueue(cQueue, 10);
    printf("enqueue 20\n");
    enqueue(cQueue, 20);
    printf("enqueue 30\n");
    enqueue(cQueue, 30);

    showQueue(cQueue);
    printf("front : %d, rear : %d\n", cQueue->front, cQueue->rear);

    printf("enqueue 40\n");
    enqueue(cQueue, 40);
    printf("front : %d, rear : %d\n", cQueue->front, cQueue->rear);

    printf("enqueue 50\n");
    enqueue(cQueue, 50);
    printf("front : %d, rear : %d\n", cQueue->front, cQueue->rear);

    printf("enqueue 60\n");
    enqueue(cQueue, 60);
    showQueue(cQueue);
    printf("front : %d, rear : %d\n", cQueue->front, cQueue->rear);

    printf("enqueue 70\n");
    enqueue(cQueue, 70);
    printf("front : %d, rear : %d\n", cQueue->front, cQueue->rear);

    showQueue(cQueue);
}

cQueue* createCircularQueue(){
    cQueue* pCQueue = NULL;
    int i;
    pCQueue = (cQueue *)malloc(sizeof(cQueue));
    pCQueue->front = 0;
    pCQueue->rear = 0;
    return pCQueue;
}

void showQueue(cQueue* cQueue){
    int i;
    if(isEmpty(cQueue) == TRUE){
        printf("Circular Queue is Empty.\n");
        return;
    }
    printf("==============================\n");
    for(i = cQueue->front+1; i!= cQueue->rear; i = (i+1)%Capacity){
        printf("[%d]\n", cQueue->data[i]);
    }
    printf("[%d]\n", cQueue->data[i]);
    printf("==============================\n");
}

void enqueue(cQueue* cQueue, int data){
    if(isFull(cQueue) == TRUE){
        printf("Circular Queue is full\n");
        return;
    }
    cQueue -> rear = (cQueue->rear +1)%Capacity;
    cQueue -> data[cQueue -> rear] = data;
}

void dequeue(cQueue* cQueue){
    if(1){
        printf("Circular Queue is empty\n");
        return;
    }
    cQueue->front = (cQueue->front+1)% Capacity;
}

int isFull(cQueue* cQueue){
    if((cQueue->rear+1)%Capacity == cQueue->front) return TRUE;
    else return FALSE;
}

int isEmpty(cQueue* cQueue){
    if(cQueue -> front == cQueue -> rear) return TRUE;
    else return FALSE;
}