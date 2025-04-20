#include <iostream>

using namespace std;

int main(){
    ios::sync_with_stdio(0);
    cin.tie(0); cout.tie(0);

    int n;
    cin >> n;

    int i;
    int arr[1001];

    for(i=0; i<n; i++){
        cin >> arr[i];
    }

    int j;
    for(i=0; i<n; i++){
        for(j=0; j<i; j++){
            if(arr[j] > arr[i]){
                int tmp = arr[j];
                arr[j] = arr[i];
                arr[i] = tmp;
            }
        }
    }

    for(i=0; i<n; i++){
        cout << arr[i] << '\n';
    }
}