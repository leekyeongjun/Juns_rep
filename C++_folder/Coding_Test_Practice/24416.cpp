#include <iostream>

using namespace std;


int r = 0;
int d = 0;

int f_r(int n){
    if(n == 1 || n == 2){
        r++;
        return 1;
        
    }
    else{
        return f_r(n-1) + f_r(n-2);
    }
}

int dp[40] = {0,1,1,};


int f_d(int n){

    for(int i = 3; i<=n; i++){
        dp[i] = dp[i-1] + dp[i-2];
        d++;
    }
    return dp[n];
}

int main(){
    int N;
    cin >> N;
    f_r(N);
    f_d(N);
    cout << r << " " << d << '\n';

}