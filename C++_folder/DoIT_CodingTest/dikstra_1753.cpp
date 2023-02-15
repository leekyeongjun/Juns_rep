#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>

#define INF 3000001
using namespace std;

vector<vector<pair<int,int>>> nodes;
vector<int> dist;
vector<bool> visited;

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int V, E, K;
    cin >> V >> E >> K;
    //V는 노드 개수, E는 에지 개수, K는 시작 노드

    nodes.resize(V+1);
    dist.resize(V+1, INF);
    visited.resize(V+1, false);

    dist[K] = 0;

    for(int i = 0; i<E; i++){
        int u,v,w;
        cin >> u >> v >> w;
        //u는 출발점, v는 도착점, w는 가중치.
        nodes[u].push_back({v,w});
    }

    priority_queue<pair<int,int>, vector<pair<int,int>>, greater<pair<int,int>>> pq;
    //Q1. 왜 단순히 노드의 번호가 아닌 {이동거리, 도착노드}의 형태로 저장하는가? -> 우선순위 큐를 쓰기 위해서
    //Q2. 왜 우선순위큐로 저장하는가? -> 자동으로 이동거리가 가장 작은것 부터 pop하기 때문에, 시간복잡도 측면에서 유리하다.

    pq.push({0,K});
    //K는 시작점이라 이동거리가 0이므로 {0,K}의 형태로 push.

    while(!pq.empty()){
        pair<int,int> c = pq.top();
        int curnode = c.second;
        //curnode 는 지금 도착한 노드번호.
        pq.pop();

        if(!visited[curnode]){
            visited[curnode] = true;
            for(auto i : nodes[curnode]){
                //curnode가 가진 모든 에지 순회
                dist[i.first] = min(dist[i.first], dist[curnode]+i.second);

                //i.first -> 목적지
                //i.second -> 목적지까지 가는 이동거리

                //i.first로 갈 수 잇는 최소 거리 
                //"i.first의 최소거리 배열값(한번도 안왔으면 무한대)" 와 "현재 노드에서 이동거리만큼 이동한 것" 중 작은값이다.


                pq.push({dist[i.first], i.first});

                //역시나 {이동거리, 도착노드}의 형태로 저장.
            }
        }
    }

    for(int i = 1 ; i<= V; i++){
        if(dist[i]!=INF) cout << dist[i] <<'\n';
        else cout << "INF" << '\n';

    }
}