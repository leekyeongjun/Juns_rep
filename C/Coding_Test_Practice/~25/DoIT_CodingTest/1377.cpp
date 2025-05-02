#include <iostream>
#include <algorithm>
#include <queue>

using namespace std;

/*

    10 1  5  2  3
    1  2  3  4  5

    1  2  3  5  10
    2  4  5  3  1
    1  2  3  4  5

    1  2  2  -1 -4
    1  2  2  1  4

    ans : 2+1 = 3
*/
int main(){

    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);
    
    int N;
    cin >> N;
    vector<pair<int,int>> origin(N);
    priority_queue<int> cmp;

    for(int i = 0; i<N; i++) {
        cin >> origin[i].first;
        origin[i].second = i;
    }
    vector<pair<int,int>> sorted(origin);
    sort(sorted.begin(), sorted.end());
    for(int i =0; i<N; i++){
        cmp.push(sorted[i].second - origin[i].second);
    }
    cout << cmp.top()+1 << '\n';
    

}