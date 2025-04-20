#include <iostream>
#include <algorithm>

using namespace std;

int* v;

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);
    
    int N;
    cin >> N;
    v = new int[N];

    for(int i = 0 ; i < N; i++) cin >> v[i];
    sort(v, v+N);

    int M;
    cin >> M;
    for(int i = 0; i<M; i++){
        int f;
        cin >> f;

        int cri = (int) ((N-1)/2);

        while(1){
            
            if(v[cri] < f){
                cri = (int) (cri+1 + N)/2;
            }
            else if(v[cri] > f){
                cri = (int) (cri-1)/2;
            }
            else if(v[cri] == f){
                cout << 1 << " "; break;
            }

            if(cri <= 0 || cri >= N){
                cout << 0 << " "; break;
            }

        }



    }
}