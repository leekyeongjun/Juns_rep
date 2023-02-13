

#include <iostream>
#include <queue>

using namespace std;

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int N, K;
    cin >> N >> K;

    priority_queue<int, vector<int>, greater<int>> pq;

    for(int i = 1; i<=K; i++){
        for(int j = 1; j<=K; j++){
            pq.push(i*j);
        }
    }

    cout << pq.top() << '\n';

}