#include <iostream>
#include <vector>


using namespace std;

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int N;
    cin >> N;

    vector<int> v1(N);
    vector<int> v2(N);

    for(int i = 0 ; i<N; i++){
        cin >> v1[i];
    }

    for(int i = 0; i<N; i++){
        int cur = v1[i];
        if(i == 0){
            v2[i] = cur;
        } 
        else{
            

        }

    }


}