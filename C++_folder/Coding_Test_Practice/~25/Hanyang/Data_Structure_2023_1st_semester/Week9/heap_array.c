#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define MAX_NODES 50
typedef struct Heap{
    int nodes[MAX_NODES];
    int lastIndex;

}Heap;

void initHeap(Heap* heap);
void insertData(Heap* heap, int data);
void printHeap(Heap heap);
void deleteData(Heap* heap);

void initHeap(Heap* heap){
    int i;
    for(i = 1; i<MAX_NODES; i++){
        heap->nodes[i] = 0;
    }
    heap -> lastIndex = 0;
}

void printHeap(Heap heap){
    int i,count, newLineIndex;
    count = 1;
    newLineIndex = 0;

    for(i=1; i<=heap.lastIndex; i++){
        printf("%d\t", heap.nodes[i]);
        if(pow(2,newLineIndex) == count){
            printf("\n");
            newLineIndex++;
            count = 0;
        }
        count++;
    }
    printf("\n\n");
}

void insertData(Heap* heap, int data){
    int index;
    if(heap->lastIndex == MAX_NODES-1){
        printf("heap is full\n");
        return;
    }

    heap->lastIndex++;
    index = heap-> lastIndex;

    while((index != 1)&& (data > heap->nodes[index/2]))
    {
        heap->nodes[index] = heap->nodes[index/2];
        index /= 2;
    }
    heap -> nodes[index] = data;
}

void deleteData(Heap* heap){
    int temp, parentIndex, childIndex;
    if(heap->lastIndex == 0){
        printf("Heap is empty\n");
        return;
    }
    if(heap->lastIndex == 1){
        heap->nodes[heap->lastIndex] = 0;
        heap->lastIndex = 0;
        return;
    }
    
    temp = heap -> nodes[heap->lastIndex];
    heap-> nodes[heap->lastIndex] = 0;
    heap->lastIndex --;

    parentIndex = 1;
    childIndex = 2;

    while(childIndex <= heap->lastIndex){

        if(heap->nodes[childIndex] < heap->nodes[childIndex+1])
            childIndex++;
        if(temp > heap->nodes[childIndex])
            break;
        heap -> nodes[parentIndex] = heap->nodes[childIndex];
        parentIndex = childIndex;
        childIndex *= 2;
    }
    heap->nodes[parentIndex] = temp;
}