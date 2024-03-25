#include <stdio.h>
#include <stdlib.h>

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
