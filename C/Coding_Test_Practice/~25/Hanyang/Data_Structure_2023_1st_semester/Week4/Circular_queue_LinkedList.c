#include <stdio.h>
#include <stdlib.h>

// Node structure
struct Node {
    int data;
    struct Node* next;
};

// Circular queue structure
struct CircularQueue {
    struct Node* front;
    struct Node* rear;
};

// Create an empty circular queue
struct CircularQueue* createQueue() {
    struct CircularQueue* queue = (struct CircularQueue*)malloc(sizeof(struct CircularQueue));
    queue->front = NULL;
    queue->rear = NULL;
    return queue;
}

// Check if the circular queue is empty
int isEmpty(struct CircularQueue* queue) {
    return (queue->front == NULL && queue->rear == NULL);
}

// Check if the circular queue is full
int isFull(struct CircularQueue* queue) {
    struct Node* new_node = (struct Node*)malloc(sizeof(struct Node));
    if (new_node == NULL)
        return 1;
    else {
        free(new_node);
        return 0;
    }
}

// Enqueue an element to the circular queue
void enqueue(struct CircularQueue* queue, int data) {
    struct Node* new_node = (struct Node*)malloc(sizeof(struct Node));
    new_node->data = data;
    if (isEmpty(queue)) {
        queue->front = new_node;
        queue->rear = new_node;
    } else {
        queue->rear->next = new_node;
        queue->rear = new_node;
    }
    queue->rear->next = queue->front; // Make the queue circular
    printf("%d enqueued to queue.\n", data);
}

// Dequeue an element from the circular queue
void dequeue(struct CircularQueue* queue) {
    if (isEmpty(queue)) {
        printf("Queue is empty!\n");
        return;
    }
    struct Node* temp = queue->front;
    printf("%d dequeued from queue.\n", temp->data);
    if (queue->front == queue->rear) { // Only one node in the queue
        queue->front = NULL;
        queue->rear = NULL;
    } else {
        queue->front = queue->front->next;
        queue->rear->next = queue->front; // Make the queue circular
    }
    free(temp);
}

// Dequeue all elements from the circular queue and free memory
void deleteQueue(struct CircularQueue* queue) {
    if (isEmpty(queue)) {
        printf("Queue is already empty!\n");
        return;
    }
    struct Node* temp = queue->front;
    while (temp != queue->rear) {
        queue->front = temp->next;
        printf("%d dequeued from queue.\n", temp->data);
        free(temp);
        temp = queue->front;
    }
    printf("%d dequeued from queue.\n", temp->data);
    free(temp);
    queue->front = NULL;
    queue->rear = NULL;
}

// Display the circular queue
void printQueue(struct CircularQueue* queue) {
    if (isEmpty(queue)) {
        printf("Queue is empty!\n");
        return;
    }
    struct Node* current = queue->front;
    printf("Queue: ");
    while (current != queue->rear) {
        printf("%d ", current->data);
        current = current->next;
    }
    printf("%d\n", current->data);
}

int main() {
    struct CircularQueue* queue = createQueue();
    enqueue(queue, 10);
    enqueue(queue, 20);
    enqueue(queue, 30);
    printQueue(queue);
    dequeue(queue);
    printQueue(queue);
    enqueue(queue, 40);
}