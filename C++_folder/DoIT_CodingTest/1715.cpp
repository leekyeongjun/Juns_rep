#include <iostream>
#include <queue>

using namespace std;

priority_queue<int, vector<int>, greater<int>> pq;

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int N;
    cin >> N;

    int sum = 0;

    for(int i = 0; i<N; i++){
        int a;
        cin >> a;
        pq.push(a);
    }

    while(pq.size() != 1){
        int cur_1 = pq.top();
        pq.pop();
        int cur_2 = pq.top();
        pq.pop();
        sum += cur_1+cur_2;
        pq.push(sum);
    }

    cout << sum << '\n';
}

