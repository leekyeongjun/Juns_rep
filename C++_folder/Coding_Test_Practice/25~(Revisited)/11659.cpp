#include <iostream>

using namespace std;

int main(){
    ios::sync_with_stdio(0); cin.tie(NULL); cout.tie(NULL);

    int n, m;
    cin >> n >> m;

    int arr[1000001] = {0,};
    
    int i;
    for (i = 1; i<=n; i++){
        int a;
        cin >> a;
        arr[i] = arr[i-1]+a;
    }

    for (i = 0; i<m; i++){
        int a, b;
        cin >> a >> b;
        cout << arr[b] - arr[a-1] << "\n";
    }

    return 0;
}
