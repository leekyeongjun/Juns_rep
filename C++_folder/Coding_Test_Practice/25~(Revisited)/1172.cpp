#include <iostream>
#include <vector>

using namespace std;

vector<int> A[1001];
int V[1001] = {0,};

int n,m,i;
int cnt = 0;

void DFS(int);

int main(){
    ios::sync_with_stdio(0); cin.tie(0); cout.tie(0);

    cin >> n >> m;
    for(i=0; i<m; i++){
        int s, e;
        cin >> s >> e;
        A[s].push_back(e);
        A[e].push_back(s);
    }

    for(int i = 1; i<=n; i++){
        if(V[i] == 0){
            cnt++;
            DFS(i);
        }
    }
    cout << cnt << '\n';
}

void DFS(int v){
    if(V[v]==1){
        return;
    }

    V[v] == 1;

    for(i=0; i<A[v].size(); i++){
        if(V[i] == 0){
            DFS(i);
        }      
    }
    
}