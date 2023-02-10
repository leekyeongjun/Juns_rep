#include <iostream>
#include <queue>

using namespace std;

class node{
public:
    int data;
    priority_queue<int, vector<int>, greater<int>> edge;
    bool visited = false;
};

node DFS_nodes[10001];
node BFS_nodes[10001];


queue<int> reservation;

void DFS(int n){
    //이미 방문한 노드일 경우 -> 함수 종료
    //방문하지 않은 노드일 경우
    // -> 방문했다고 체크
    // -> 해당 노드의 edge에 대한 재귀적 함수 호출
    
    if(DFS_nodes[n].visited == true) return;
    else{
        cout << DFS_nodes[n].data << ' ';
        DFS_nodes[n].visited = true;

        while(!DFS_nodes[n].edge.empty()){
            DFS(DFS_nodes[n].edge.top());
            DFS_nodes[n].edge.pop();
        }
    }
}

void BFS(){
    //노드 탐색 (queue에서 pop)
    //노드 안에 있는 모든 edge를 돌며
    // -> 이미 방문한 node이면 queue에 안넣을 거임
    // -> 방문하지 않은 node라면 queue에 넣을 거임
    // while(queue 가 다 빌때 까지)
        //queue안에 있는 거 대상으로 BFS재귀 돌림

    int cur = reservation.front();
    if(BFS_nodes[cur].visited == true){
        reservation.pop();
        return;
    }
    else{
        BFS_nodes[cur].visited = true;
        cout << BFS_nodes[cur].data << ' ';

        reservation.pop();
    }

    while(!BFS_nodes[cur].edge.empty()){
        if(!BFS_nodes[BFS_nodes[cur].edge.top()].visited){
            reservation.push(BFS_nodes[cur].edge.top());
        }
        BFS_nodes[cur].edge.pop();
    }

    while(!reservation.empty()){
        BFS();
    }

}

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int N,E,S;
    cin >> N >> E >> S;

    for(int i =1; i<=N; i++){
        node n;
        n.data = i;
        DFS_nodes[i] = n;
        BFS_nodes[i] = n;
    }

    for(int i = 0; i<E; i++){
        int id, e;
        cin >> id >> e;
        DFS_nodes[id].edge.push(e);
        BFS_nodes[id].edge.push(e);

        DFS_nodes[e].edge.push(id);
        BFS_nodes[e].edge.push(id);
    }

    
    DFS(S);
    cout << '\n';
    reservation.push(S);
    BFS();
    cout << '\n';
}