#include <iostream>

using namespace std;

int main(){
    int l = 1;
    int r = 1;
    int sum = 1;
    int cnt = 1;

    int N;
    cin >> N;

    while(r != N){
        if(sum == N){
            cnt++;
            r++;
            sum+=r;
        }
        else if(sum > N){
            sum -= l;
            l++;
        }
        else if(sum < N){
            r++;
            sum+=r;
        }
    }

    cout << cnt << '\n';

}