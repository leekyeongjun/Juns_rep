#include <iostream>
#include <math.h>

using namespace std;


int nums[10000001] = {0,};

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);
    
    int N,M;
    cin >> N >> M;

    for(int i = 2; i<= sqrt(M); i++){
        for(int j = 2; j<= sqrt(M); j++){
            int cur = i*j;
            if(cur <= M){
                nums[cur] = 1;
            }
        }
    }

    for(int i = N; i<=M; i++){
        if(nums[i] == 0) cout << i << '\n';
    }

}