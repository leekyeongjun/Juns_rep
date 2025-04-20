#include <iostream>
#include <vector>
#include <queue>
#include <limits.h>
#include <algorithm>
#define edge pair<int,int>

using namespace std;

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);
    int n,m,k;
    cin >> n >> m >> k;
    vector<vector<edge>> nodes(n+1);
    vector<priority_queue<int>> minDistpq(n+1);

    priority_queue<edge, vector<edge>, greater<edge>> pq;

    for(int i = 0 ;i<m ;i++){
        int u, v, w;
        cin >> u >> v >> w;
        nodes[u].push_back({v,w});
    }


    minDistpq[1].push(0);
    pq.push({0,1});

    while(!pq.empty()){
        edge cur = pq.top();
        pq.pop();
        int curnodeId = cur.second;
        for(auto i : nodes[curnodeId]){
            if(minDistpq[i.first].size() < k){
                minDistpq[i.first].push(cur.first+ i.second);
                pq.push({cur.first+i.second, i.first});
                //minDistpq[i.first].push(minDistpq[curnodeId].top()+i.second);
                //pq.push({minDistpq[i.first].top(), i.first});
            }
            else if(minDistpq[i.first].top() > cur.first + i.second/*minDistpq[curnodeId].top()+i.second*/){
                minDistpq[i.first].pop();
                minDistpq[i.first].push(cur.first+ i.second);
                pq.push({cur.first+i.second, i.first});
                //minDistpq[i.first].push(minDistpq[curnodeId].top()+i.second);
                //pq.push({minDistpq[i.first].top(), i.first});
            }
        }
    }

    for(int i = 1; i<=n; i++){
        if(minDistpq[i].size() == k) cout << minDistpq[i].top() << '\n';
        else cout << -1 << '\n';
    }

}