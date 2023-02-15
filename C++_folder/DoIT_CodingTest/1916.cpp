#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>
#include <limits.h>

using namespace std;

typedef struct{
    int destination;
    int weight;
}node;

vector<vector<node>> nodes;
vector<bool> visited;
vector<int> minDist;
priority_queue<pair<int,int>, vector<pair<int,int>>, greater<pair<int,int>>> pq;

int main(){

    ios::sync_with_stdio(0); cin.tie(NULL); cout.tie(NULL);
    int N,M;
    cin >> N >> M;

    nodes.resize(N+1);
    visited.resize(N+1, false);
    minDist.resize(N+1, INT_MAX);
    
    


    for(int i = 0; i<M; i++){
        int u,v,w;
        cin >> u >> v >> w;
        node buf;
        buf.destination = v;
        buf.weight = w;
        nodes[u].push_back(buf);
    }


    int s, e;
    cin >> s >> e;
    minDist[s] = 0;
    pq.push({0,s});

    while(!pq.empty()){
        pair<int,int> cur = pq.top();
        pq.pop();
        int curnodeId = cur.second;
        if(curnodeId == e) break;
        visited[curnodeId] = true;

        for(auto i : nodes[curnodeId]){
            if(!visited[i.destination]){
                minDist[i.destination] = min(minDist[i.destination], minDist[curnodeId]+i.weight);
                pq.push({minDist[i.destination], i.destination});
            }
        }
    }

    cout << minDist[e] << '\n';

}
