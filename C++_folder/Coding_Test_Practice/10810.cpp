#include <iostream>
#include <vector>
using namespace std;


int main(){
    ios::sync_with_stdio(0); cin.tie(NULL); cout.tie(NULL);
    int N, M;
    cin >> N >> M;
    vector<int> basket(N+1,0);

    for(int i = 1 ; i<=N; i++){
        basket[i] = i;
    }
        for(int i = 0; i<M; i++){
        int a, b, tmp;
    
        cin >> a >> b;

        if(a!=b){
            tmp = basket[a];
            basket[a] = basket[b];
            basket[b] = tmp;
        }    
    }

    for(int i = 1; i<=N; i++){
        cout << basket[i] << " ";
    }
    cout << '\n';
}