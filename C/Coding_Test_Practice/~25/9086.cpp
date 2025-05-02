#include <iostream>

using namespace std;

int main(){
    ios::sync_with_stdio(0); cin.tie(NULL); cout.tie(NULL);
    int a;
    cin >> a;
    for(int i = 0 ; i <a; i++){
        string b;
        cin >> b;

        cout << b.at(0) << b.at(b.size()-1) << '\n';
    }

}