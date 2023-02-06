#include <iostream>
#include <queue>
#include <time.h>


/*

    3  1  4  3  2

    1  2  3  3  4
    0
    0  0
    0  0  0
    0  0  0  0
    0  0  0  0  0

    1*(N) + 2(N-1)...
*/
using namespace std;

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int N;
    cin >> N;

    double ans = 0;

    priority_queue<int, vector<int>, greater<int>> pq;
    clock_t start = clock();

    for(int i = 0; i<N; i++){
        int a;
        cin >> a;
        pq.push(a);
    }

    for(int i = N; i>0; i--){
        ans += (pq.top())*i;
        pq.pop();
    }

    cout << ans << '\n';

    clock_t end = clock();
    cout << (double)((end-start)/CLOCKS_PER_SEC) << "ms 소요." <<'\n';
}