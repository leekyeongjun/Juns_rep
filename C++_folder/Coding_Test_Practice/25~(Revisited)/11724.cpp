#include <iostream>
#include <vector>

using namespace std;

vector<int> A[1001];
bool V[1001] = {false,};

int n, m;
int i, j;

void DFS(int id){
    if(V[id]) return;
    V[id] = true;

    int sz = A[id].size();
    for(i=0; i<sz; i++){
        DFS(A[id][i]);
    }
}

int main(){
    ios::sync_with_stdio(0); cin.tie(NULL); cout.tie(NULL);

    int cnt = 0;
    cin >> n >> m;

    for(i=0; i<m; i++){
        int u, v;
        cin >> u >> v;
        A[u].push_back(v);
        A[v].push_back(u);
    }

    for(i=1; i<=n; i++){
        if(V[i]==false){
            DFS(i);
            cnt++;
        }
    }

    cout << cnt << '\n';

}