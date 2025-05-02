#include <iostream>
#include <vector>
#include <stack>

using namespace std;

int main(){
    ios::sync_with_stdio(0); cin.tie(NULL); cout.tie(NULL);
    int N, M;
    cin >> N >> M;

    
    vector<int> n(N+1);
    
    for(int i = 0; i<=N; i++){
        n[i] = i;
    }

    for(int i = 0; i<M; i++){
        int s,e;
        cin >> s >> e;
        stack<int> n_p;
        for(int j = s; j <= e; j++){
            n_p.push(n[j]);
        }
        for(int j=s; j<=e; j++){
            n[j] = n_p.top();
            n_p.pop();
        }
    }

    for(int i = 1; i<=N; i++){
        cout << n[i] << " ";
    }
    cout << '\n';

}