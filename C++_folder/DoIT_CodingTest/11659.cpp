#include <iostream>

using namespace std;

int S[100001] = {0,};

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);
    
    int N, M;
    cin >> N >> M;
    for(int i = 1; i<=N; i++){
        int a;
        cin >> a;
        S[i] = S[i-1] + a;
    }

    // 5 4 3 2 1
    // 0 5 9 12 14 15

    for(int i =0; i<M; i++){
        int s, e;
        cin >> s >> e;
        cout << S[e] - S[s-1] << '\n';
    }

}