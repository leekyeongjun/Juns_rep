#include <iostream>

using namespace std;
int n[20] = {0,};

int main(){
    
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);
    
    int L = 0;
    int R = 0;
    int C = 0;
    int N;

    cin >> N;

    for(int i = 1; i<=N; i++) n[i] = n[i-1] + i;
    

    while(R <= N){
        int tmp = n[R] - n[L];
        if(tmp == N) {C++; L++;}
        else if(tmp < N) R++;
        else if(tmp > N) L++;
    }

    cout << C << '\n';



}

