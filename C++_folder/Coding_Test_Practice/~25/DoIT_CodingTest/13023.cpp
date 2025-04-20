#include <iostream>
#include <vector>

using namespace std;

vector<bool> checker;
vector<vector<int>> v;

bool ans = false;

void DFS(int n, int depth){
    if(depth == 5 || ans){
        ans = true;
        return;
    }

    checker[n] = true;
    
    for(int i : v[n]){
        if(checker[i] == false){
            DFS(i, depth+1);
        }
    }

    checker[n] = false;
}

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int N,M;
    cin >> N >> M;

    checker.resize(N, false);
    v.resize(N);

    for(int i = 0; i<M; i++){
        int l, r;
        cin >> l >> r;
        v[l].push_back(r);
        v[r].push_back(l);
    }

    for(int i = 0; i<=N; i++){
        DFS(i,1);
        if(ans) break;
    }

    int r = (ans) ? 1 : 0;
    cout << r << '\n';


}