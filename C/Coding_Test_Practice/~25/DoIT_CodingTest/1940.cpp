#include <iostream>
#include <algorithm>
#include <vector>

using namespace std;

vector<int> v;

int main(){

    int N,M;
    cin >> N >> M;

    for(int i =0; i<N; i++){
        int a;
        cin >> a;
        v.push_back(a);
    }

    sort(v.begin(), v.end());

    int f = 0;
    int l = N-1;
    int cnt = 0;

    while(f < l){
        if(v[f] + v[l] == M){
            cnt++;
            l--;
            f++;
        }
        else if(v[f] + v[l] < M){
            f++;
        }
        else{
            l--;
        }
    }

    cout << cnt << '\n';

}