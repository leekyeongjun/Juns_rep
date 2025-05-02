#include <iostream>

using namespace std;

bool arr[1000001] = {false,};
int main(){

    ios::sync_with_stdio(0); cin.tie(0); cout.tie(0);
    int n, m;
    cin >> n >> m;

    int i;
    for(i = 2; i<=m; i++){
        if(arr[i] == false){
            int t = i;
            int j = 2;
            for(j; t*j <= m; j++){
                arr[t*j] = true;
            }
        }
    }

    for(i=n; i<=m; i++){
        if(!arr[i] && i != 1){
            cout << i << '\n';
        }

    }

}