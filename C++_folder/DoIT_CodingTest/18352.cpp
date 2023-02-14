#include <iostream>
#include <vector>
#include <queue>

using namespace std;

typedef struct{
    bool visited = false;
    int depth = -1;
    vector<int> edges;
}node;

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int N,M,K,X;

    // N : 도시 총 개수
    // M : 도시간 도로의 총 개수
    // K : 목표하는 이동횟수
    // X : 시작하는 위치


    cin >> N >> M >> K >> X;
    vector<node> nodes(N+1);

    for(int i = 0; i<M; i++){
        int start, end;
        cin >> start >> end;
        nodes[start].edges.push_back(end);
    }

    queue<int> reservation;
    nodes[X].depth++;
    reservation.push(X);

    while(!reservation.empty()){
        int cur = reservation.front();
        reservation.pop();
        nodes[cur].visited = true;
        for(auto i : nodes[cur].edges){
            if(nodes[i].depth == -1){
                nodes[i].depth = nodes[cur].depth+1;
                reservation.push(i);
            }
        }
    }

   
    priority_queue<int, vector<int>, greater<int>> pq;
    
    for(int i = 1; i<=N; i++){
        if(nodes[i].depth == K){
            pq.push(i);
        }
    }
    if(pq.empty()) cout << -1 << '\n';
    else{
        while(!pq.empty()){
            cout << pq.top() << '\n';
            pq.pop();
        }
        
    }


}