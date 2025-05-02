#include <iostream>
#include <vector>
#include <queue>
#include <memory.h>
#include <algorithm>

using namespace std;

vector<int> A[1001];
bool V[1001]={false,};

int n, m, v , i;

void DFS(int id){
    
    if(V[id]) {
        
        return;
    }
    
    V[id] = true;
    cout << id << " ";

    for(int i : A[id]){
        if(!V[i]) DFS(i);
    }
}

queue<int> q;

void BFS(){
    int t = q.front();
    cout << t << " ";
    q.pop();

    for(int i : A[t]){
        if(!V[i]) {
            V[i] = true;
            q.push(i);
        }
    }

}
int main(){
    ios::sync_with_stdio(NULL);
    cin.tie(0); cout.tie(0);

    cin >> n >> m >> v;

    for(i=0; i<m; i++){
        int u,o;
        cin >> u >> o;

        A[u].push_back(o);
        A[o].push_back(u);
    }

    for(int i = 1; i<= n; i++){
        sort(A[i].begin(), A[i].end());
    }   
 

    DFS(v);

    cout << '\n' ;

    memset(V, false, 1000*sizeof(bool));

    q.push(v);
    V[v] = true;
    while(!q.empty()) {
        BFS();
    }

    cout << '\n' ;

}