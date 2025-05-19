#include <iostream>
#include <vector>
#include <queue>



using namespace std;

int main(){
    vector<vector<int>> g;
    vector<int> c;
    queue<int> q;
    int n,m;
    int i;

    ios::sync_with_stdio(0);
    cin.tie(0); cout.tie(0);

    cin >> n >> m;
    g.resize(n+1);
    c.resize(n+1);

    for(i=0; i<m; i++){
        int a,b;
        cin >> a >> b;
        g[a].push_back(b);
        c[b]++;
    }
    /*
    for(int i = 0; i<n+1; i++){
        cout << i <<" : ";
        for (int j = 0; j < g[i].size(); j++){
            cout << g[i][j] << " ";
        }cout << ", size = " << g[i].size() <<'\n';
    }*/

    for(i = 1; i<=n; i++){
        if(c[i] == 0){
            q.push(i);
        }
    }

    while(!q.empty()){
        int t = q.front();
        q.pop();
        cout << t << " ";
        for(int j : g[t]){
            c[j] --;
            if(c[j] == 0){
                q.push(j);
            }
        }
    }
    cout << '\n';

}