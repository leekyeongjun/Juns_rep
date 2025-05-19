#include <iostream>
#include <vector>
#include <queue>

#define INF 3000001
using namespace std;


class n{
public:
    int t;
    int w;

    n(int a, int b){
        t = a;
        w = b;
    }
};

struct compare{
    bool operator()(n &a, n &b){
        return a.w > b.w;
    }
};

priority_queue<n,vector<n>, compare> pq;
vector<vector<n>> g;
vector<int> m;
vector<bool> v;



int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int V,E,S;
    cin >> V >> E >> S;

    g.resize(V+1);
    m.resize(V+1, INF);
    v.resize(V+1, false);

    int i;
    for(i =0; i<E; i++){
        int u,v,w;
        cin >> u >> v >> w;
        n nn(v,w);
        g[u].push_back(nn);
    }

    m[S] = 0;
    n start(S,0);
    pq.push(start);

    while(!pq.empty()){
        n tp = pq.top();
        pq.pop();
        
        int curnode = tp.t;

        if(v[curnode]){
            continue;
        }

        v[curnode] = true;
        for(int i = 0; i<g[curnode].size(); i++){
            n tmp = g[tp.t][i];
            int next = tmp.t;
            int value = tmp.w;
            if(m[next] > m[curnode]+value){
                m[next] = m[curnode]+value;
                n np(next, m[next]);
                pq.push(np);
            }
        }
    }

    for(int j = 1; j<=V; j++){
        if(m[j] == INF) cout << "INF ";
        else cout << m[j] << ' '; 
    }cout << '\n';


}