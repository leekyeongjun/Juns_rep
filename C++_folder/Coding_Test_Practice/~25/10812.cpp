#include <iostream>
#include <vector>
#include <queue>

using namespace std;

int main(){
    ios::sync_with_stdio(0); cin.tie(NULL); cout.tie(NULL);
    int N, M;
    cin >> N >> M;
    vector<int> b(N+1);
    
    for(int i = 1; i<=N; i++) b[i] = i;

    for(int i = 0; i<M; i++){
        int s, e, m;
        cin >> s >> e >> m;

        queue<int> st;
        vector<int> ans;

        for(int j = 1; j<s; j++){
            ans.push_back(b[j]);
        }

        for(int j = s; j< m; j++){
            st.push(b[j]);
        }

        for(int j = m; j<= e; j++){
            ans.push_back(b[j]);
        }

        while(!st.empty()){
            ans.push_back(st.front());
            st.pop();
        }

        for(int j = e+1; j<= N; j++){
            ans.push_back(b[j]);
        }

        for(int k=1; k<=N; k++){
            b[k] = ans[k-1];
        }

    }

    for(int i = 1; i<= N; i++){
        cout << b[i] << " ";
    }cout<< '\n';

}