#include <iostream>

using namespace std;

int main(){

    int c[6] = {1,1,2,2,2,8};
    for(int i = 0; i<6; i++){
        int a;
        cin >> a;
        c[i]-= a;
    }

    for(int i = 0; i<6; i++){
        cout << c[i] << " ";
    }cout <<'\n';
}