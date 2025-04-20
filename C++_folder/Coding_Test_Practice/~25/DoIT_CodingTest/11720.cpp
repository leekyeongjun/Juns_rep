#include <iostream>
#include <vector>

using namespace std;

int a = 0;

int main(){
    int n;
    cin >> n;
    string s;
    cin >> s;

    for(int i=0; i<n; i++){
        a += s[i]-'0';
    }

    cout << a << '\n';

}