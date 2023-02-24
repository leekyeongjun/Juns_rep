#include <iostream>
#include <vector>
#include <algorithm>
#include <limits.h>

using namespace std;

typedef struct{
    int Start = 0;
    int End = 0;
    int Weight = 0;
}edge;

int main(){

    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int N, E;
    cin >> N >> E;

    vector<edge> edges;
    vector<long> minDist(N+1, LONG_MAX);
    minDist[1] = 0;

    for(int i = 0; i<E; i++){
        int s, e, w;
        cin >> s >> e >> w;
        edges.push_back({s,e,w});
    }

    for(int i = 0; i<N-1; i++){
        for(auto edge : edges){
            if(minDist[edge.Start] != LONG_MAX && minDist[edge.End] > minDist[edge.Start]+edge.Weight){
                minDist[edge.End] = minDist[edge.Start]+edge.Weight;
            }
        }
    }
    bool minus = false;
    for(auto checker : edges){
        if(minDist[checker.Start] != LONG_MAX && minDist[checker.End] > minDist[checker.Start]+ checker.Weight){
            minus = true;
        } 
    }

    if(!minus){
        for(int i = 2; i<=N; i++) {
            if(minDist[i] == LONG_MAX){
                cout << -1 << '\n';
            }
            else{
                cout << minDist[i] << '\n';
            }
        }
    }
    else{
        cout << -1 << '\n';
    }
}
