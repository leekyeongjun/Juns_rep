//===============================================================================================//
//BST
#include <stdio.h>
#include <stdlib.h>

typedef struct Node
{
    int data;
    struct Node * leftChild;
    struct Node * rightChild;
}Node;

void insertTreeNode(Node ** p, int value);
void printTreePreorder(Node* pNode);
void printTreeInorder(Node* pNode);
void printTreePostorder(Node* pNode);

void insertTreeNode(Node ** p, int value){
    if((*p) == NULL){
        (*p) = (Node*)malloc(sizeof(Node));
        (*p) -> data =value;
        (*p) -> leftChild = NULL;
        (*p) -> rightChild = NULL;
    }
    else if((*p) -> data > value){
        insertTreeNode(&((*p)-> leftChild), value);
    }
    else if((*p) -> data < value){
        insertTreeNode(&((*p) -> rightChild), value);
    }
    else{
        //same value is already here.
    }
}

void printTreePreorder(Node* pNode){
    if(pNode  == NULL){
        return;
    }
    printf("%3d", pNode->data);
    printTreePreorder(pNode->leftChild);
    printTreePreorder(pNode->rightChild);
}
void printTreeInorder(Node* pNode){
    if(pNode == NULL){
        return;
    }
    
    printTreeInorder(pNode->leftChild);
    printf("%3d", pNode->data);
    printTreeInorder(pNode->rightChild);
}
void printTreePostorder(Node* pNode){
    if(pNode == NULL){
        return;
    }
    printTreePostorder(pNode->leftChild);
    printTreePostorder(pNode->rightChild);
    printf("%3d", pNode->data);
}

//===============================================================================================//
//HEAP
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
//===============================================================================================//
//SPARSE MATRIX
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


//===============================================================================================//
//AVL TREE
#define Max(x,y) ((x) > (y))?(x):(y)

typedef struct AvlNode{
    int data;
    struct AvlNode *left, *right;
    int Height;
}AvlNode;

int height(AvlNode* node){
    if(node == NULL)
        return -1;
    else
        return node->Height;
}

AvlNode* rotateLL(AvlNode* parent){
    AvlNode* child = parent->left;
    parent->left = child->right;
    child->right = parent;

    parent->Height = Max(height(parent->left), height(parent->right))+1;
    child->Height = Max(height(child->left), parent->Height)+1;

    return child;
}

AvlNode* rotateRR(AvlNode* parent){
    AvlNode* child = parent->right;
    parent->right = child->left;
    child->left = parent;

    parent->Height = Max(height(parent->left), height(parent->right))+1;
    child->Height = Max(parent->Height, height(child->right))+1;

    return child;
}

AvlNode* rotateLR(AvlNode* parent){
    AvlNode* child = parent->left;
    parent->left = rotateRR(child);
    return rotateLL(parent);
}

AvlNode* rotateRL(AvlNode* parent){
    AvlNode* child = parent->right;
    parent->right = rotateLL(child);
    return rotateRR(parent);
}

AvlNode* avlAdd(AvlNode* root, int data){
    if(root == NULL){
        root = (AvlNode*)malloc(sizeof(AvlNode));
        if(root == NULL){
            exit(1);
        }

        root->data = data;
        root->Height = 0;
        root->left = root->right = NULL;
    }
    else if(data < root->data){
        root->left = avlAdd(root->left, data);
        if(height(root->left) - height(root->right) == 2){
            if(data < root -> left -> data){
                root = rotateLL(root);
            }
            else{
                root = rotateLR(root);
            }
        }
    }
    else if(data > root->data){
        root->right = avlAdd(root->right, data);
        if(height(root->right) - height(root->left) == 2){
            if(data > root->right->data){
                root = rotateRR(root);
            }
            else{
                root = rotateRL(root);
            }
        }
    }
    else{
        printf("중복 키 삽입 오류\n");
        exit(1);
    }
    root->Height = Max(height(root->left), height(root->right))+1;
    return root;
}

AvlNode* avlSearch(AvlNode* node, int key){
    if(node == NULL) return NULL;
    if(key == node->data) return node;
    else if(key < node->data)
        return avlSearch(node->left, key);
    else
        return avlSearch(node->right, key);
}

AvlNode* inorderTraveling(AvlNode* root){
    if(root!=NULL){
        inorderTraveling(root->left);
        printf("[%d] ", root->data);
        inorderTraveling(root->right);
    }
}

//===============================================================================================//
//B TREE

#define M_WAY 3

typedef struct BTNode{
    int n;
    int isLeaf;
    int isRoot;
    int keys[M_WAY];

    struct  BTNode* childs[M_WAY+1];
}BTNode;

BTNode* initBTNode();
BTNode* BTInsert(BTNode* root, int key);
BTNode* splitChild(BTNode* root);
void inorderTraversal(BTNode* root);

BTNode* initBTNode(){
    int i;
    BTNode* newBTNode;
    newBTNode = (BTNode*)malloc(sizeof(BTNode));
    newBTNode->n = 0;
    newBTNode->isLeaf = 1;
    newBTNode->isRoot = 0;

    for(i = 0; i<M_WAY+1; i++){
        newBTNode->childs[i] = NULL;
    }
    
    return newBTNode;
}

BTNode* BTInsert(BTNode* root, int key){
    int i,pos;
    BTNode* split;

    //해당 노드가 leaf노드일 때
    if(root->isLeaf){
        //노드의 키 값들 중 key가 들어갈 위치 탐색
        for(pos = 0; pos <root->n; pos++)
            if(root->keys[pos]>key)
                break;
        //정렬을 통해 위치를 맞춰주고 pos위치에 key를 삽입
        for(i = root->n; i>pos; i--)
            root->keys[i] = root->keys[i-1];
        root->keys[pos] = key;
        root->n++;
        // insertion 수행 후 노드의 키 값의 개수가 다 찼을 때 
        //해당노드가 root노드인 경우에만 Split 수행
        if(root->n == M_WAY && root->isRoot)
            return splitChild(root);
        //그냥 lear노드인 경우 상위함수에서 split수행
        return root;
    }
    //해당 노드가 leaf노드가 아닐때
    else{
        //노드의 키 값들 중 key가 들어갈 위치 탐색
        for(pos = 0; pos<root->n; pos++){
            if(root->keys[pos]>key)
                break;
        }
        //해당위치에 존재하는 child노드로 들어가 leaf노드까지 탐색
        root->childs[pos] = BTInsert(root->childs[pos], key);
        //insertion 수행 후 child노드의 키의 개수가 다 찼을 때
        if((root->childs[pos])->n == M_WAY){
            //child 노드에 대해 split수행
            split = splitChild(root->childs[pos]);
            //split수행후 적절하게 parent 노드에 추가
            for(i = root->n; i>pos; i--){
                root->keys[i] = root->keys[i-1];
                root->childs[i+1] = root->childs[i];
            }
            root->keys[pos] = split->keys[0];
            root->n++;
            root->childs[pos] = split->childs[0];
            root->childs[pos+1] = split->childs[1];
        }
        //최종적으로 Root노드가 실제 b-Tree의 Root노드인 경우 중에
        //Key의 개수가 다 찼을 때 split수행
        if(root->n == M_WAY && root->isRoot){
            return splitChild(root);
        }
        return root;
    }
}

BTNode* splitChild(BTNode* root){
    int i, mid;


    BTNode* newParent;
    BTNode* newSibling;

    newParent = initBTNode();
    newParent -> isLeaf = 0;
    if(root->isRoot){
        newParent -> isRoot = 1;
    }
    root->isRoot = 0;

    newSibling = initBTNode();
    newSibling -> isLeaf = root->isLeaf;

    //root 노드의 중간지점을 정하고
    //오른쪽 key값들은 newSibling 노드로 이동

    mid = (M_WAY-1)/2;
    for(i = mid+1; i<M_WAY; i++){
        newSibling->childs[i-(mid+1)] = root->childs[i];
        newSibling->keys[i-(mid+1)] = root->keys[i];
        newSibling->n++;

        root->childs[i] = NULL;
        root->keys[i] = 0;
        root->n--;
    }

    //이떄 child node pointer는 키값보다 1개 많으므로
    //for문이 끝난 후 한번 더 수행
    newSibling -> childs[i-(mid+1)] = root->childs[i];
    root->childs[i] = NULL;
    
    //root 노드에 중간에 위치했던 key값들을 newParent노드로 이동
    newParent -> keys[0] = root->keys[mid];
    newParent -> n++;
    root->keys[mid] = 0;
    root->n--;
    //newParent 노드의 child노드로 root, newSibling 노드를 연결
    newParent -> childs[0] = root;
    newParent -> childs[1] = newSibling;
    
    return newParent;
}

void inorderTraversal(BTNode* root){
    int i;
    printf("\n");
    for(i = 0; i<root->n; i++){
        if(!(root->isLeaf)){
            inorderTraversal(root->childs[i]);
            printf("    ");
        }
        printf("%d", root->keys[i]);
    }
    if(!(root->isLeaf)){
        inorderTraversal(root->childs[i]);
    }
    printf("\n");
}

int main(){
    BTNode* root;
    int i,n,t;

    root = initBTNode();
    root->isRoot = 1;

    printf("넣을 데이터의 개수 :");
    scanf("%d", &n);
    for(i =0; i<n; i++){
        printf("데이터를 입력하세요. : ");
        scanf("%d", &t);
        root = BTInsert(root, t);
    }
    printf("트리 출력. \n");
    inorderTraversal(root);

    return 0;
}

//===============================================================================================//
//BFS


#define MAX_SIZE 1000
#define MAX_VERTICES 10
#define TRUE 1
#define FALSE 0

int visited[MAX_VERTICES];

typedef struct Queue{
    int queue[MAX_SIZE+1];
    int rear;
    int front;
}Queue;

typedef struct Graph{
    int adjMatrix[MAX_VERTICES][MAX_VERTICES];
    int n;
}Graph;

void initQueue(Queue* q){
    q->front = 0;
    q->rear = 0;
}

int isFull(Queue *q){
    if((q->rear+1)%MAX_SIZE == q->front) return 1;
    else return 0;
}

int isEmpty(Queue * q){
    if(q->front == q->rear) return 1;
    else return 0;
}

void enqueue(Queue *q, int data){
    if(isFull(q)) printf("Queue is full!");
    else{
        q->queue[q->rear]  =data;
        q->rear = (q->rear + 1) % MAX_SIZE;
    }
}

int dequeue(Queue* q){
    int tmp = -1;
    if(isEmpty(q)) prinf("Queue is Empty\n");
    else{
        tmp = q->queue[q->front];
        q->front = (q->front+1) % MAX_SIZE;
    }
    return tmp;
}
void init(Graph *g){
    int i,j;
    g->n = 0;
    for(i = 0; i<MAX_VERTICES; i++){
        for(j = 0; j<MAX_VERTICES; j++){
            g->adjMatrix[i][j] = 0;
        }
    }
}

int insertVertex(Graph * g, int v){
    if(g->n == MAX_VERTICES){
        printf("Too many Vertex\n");
    }
    g->n++;
}

void insertEdge(Graph *g, int u, int v){
    if(u >= g->n || v >= g->n){
        printf("invalid index number\n");
        return;
    }
    g->adjMatrix[u][v] = 1;
    g-> adjMatrix[v][u] = 1;
}


void bfs(Graph *g, int v){
    int w, search_v;
    Queue q;
    initQueue(&q);
    visited[v] = TRUE;
    enqueue(&q,v);

    while(!isEmpty(&q)){
        search_v = dequeue(&q);
        printf("%d->", search_v);

        for(w = 0; w< MAX_VERTICES; w++){
            if(g->adjMatrix[search_v][w] == 1 && visited[w] == FALSE){
                visited[w] = TRUE;
                enqueue(&q, w);
            }
        }
    }
}

//===============================================================================================//
//DFS
#define MAX_VERTICES 10
#define TRUE 1
#define FALSE 0

int visited[MAX_VERTICES];

typedef struct Graph{
    int adjMatrix[MAX_VERTICES][MAX_VERTICES];
    int n;
}Graph;

void init(Graph *g){
    int i,j;
    g->n = 0;
    for(i = 0; i<MAX_VERTICES; i++){
        for(j = 0; j<MAX_VERTICES; j++){
            g->adjMatrix[i][j] = 0;
        }
    }
}

int insertVertex(Graph * g, int v){
    if(g->n == MAX_VERTICES){
        printf("Too many Vertex\n");
    }
    g->n++;
}

void insertEdge(Graph *g, int u, int v){
    if(u >= g->n || v >= g->n){
        printf("invalid index number\n");
        return;
    }
    g->adjMatrix[u][v] = 1;
    g-> adjMatrix[v][u] = 1;
}

void dfs(Graph *g, int v){
    int w;
    visited[v] = TRUE;
    printf("%d->", v);

    for(w =0; w < MAX_VERTICES; w++){
        if(g->adjMatrix[v][w] == 1 && visited[v] == FALSE){
            dfs(g,w);
        }
    }
}

//===============================================================================================//
//Prim

#define TRUE 1
#define FALSE 0
#define MAX 7
#define INF 1000

int graph[MAX][MAX] = {
    {0, 28, INF, INF, 10 , INF},
    {28, 0, 16, INF, INF, INF, 14},
    {INF,16,0,12,INF,INF,INF},
    {INF,INF,12,0,22,INF,18},
    {INF,INF,INF,22,0,25,24},
    {10,INF,INF,INF,25,0,INF},
    {INF,14,INF,18,24,INF,0}
};

int selected[MAX];
int dist[MAX];

int getMinVertex(int n){
    int v,i;
    for(i=0; i<n; i++){
        if(!selected[i]){
            v = i;
            break;
        }
    }
    for(i = 0; i<n; i++)
        if(!selected[i] && (dist[i] < dist[v])) v= i;
    return v;
}

void prim(int s, int n){
    int i,u,v;
    for(u = 0; u<n; u++) dist[u] = INF;

    dist[s] = 0;
    for(i = 0; i<n; i++){
        u = getMinVertex(n);
        selected[u] = TRUE;
        printf("%d->", u);
        for(v = 0; v < n; v++){
            if(graph[u][v] != INF){
                dist[v] = graph[u][v];
            }
        }
    }
}

