#include <iostream>

using namespace std;



int main(){
    float s[1001];
    float M = -1;
    int M_id;

    float T = 0;
    int N;
    cin >> N;

    for(int i = 0; i <N; i++){
        int a;
        cin >> a;
        if(M <= a) {
            M = a;
            M_id = i;
        }

        s[i] = a;
    }

    for(int i =0; i<N; i++){
        int tmp = s[i];
        s[i] = tmp/M*100;
        
    }
    
    for(int i =0; i<N; i++){
        T+=s[i];
    }

    cout << T/N << '\n';

}