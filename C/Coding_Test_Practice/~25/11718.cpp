#include <iostream>

using namespace std;

int main(){

    ios::sync_with_stdio(0); cin.tie(NULL); cout.tie(NULL);

    for(int i = 0; i<100; i++){
        string a;
        getline(cin, a);
        cout << a << '\n';
    }
}