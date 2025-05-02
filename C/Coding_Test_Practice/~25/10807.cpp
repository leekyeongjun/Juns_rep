#include <iostream>
#include <vector>
using namespace std;


int main(){
    ios::sync_with_stdio(0); cin.tie(NULL); cout.tie(NULL);
    int N;
    cin >> N;

    vector<int> nums(N);
    for(int i = 0; i< N; i++){
        cin >> nums[i];
    }

    int cnt = 0;
    int v;
    cin >> v;

    for(int i =0; i<N; i++){
        if(nums[i] == v) cnt ++;
    }
    cout << cnt << '\n';

}