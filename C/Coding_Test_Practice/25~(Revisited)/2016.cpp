#include <iostream>

using namespace std;

int main(){
    ios::sync_with_stdio(0); cin.tie(NULL); cout.tie(NULL);

    int n;
    cin >> n;

    int start = 1;
    int end = 1;
    int sum = 1;
    int cnt = 1;

    while(end < n){
        if(sum < n){
            end ++;
            sum += end;
        }
        else if(sum == n){
            cnt ++;
            sum -= start;
            start ++;
        }
        else{
            sum -= start;
            start ++;
        }
    }

    cout << cnt<< '\n';
    return 0;
}