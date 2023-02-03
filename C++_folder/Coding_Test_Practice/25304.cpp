#include <iostream>

using namespace std;

long long x;
int n;


int main(){
    cin >> x >> n;
    

    for(int i=0; i<n; i++){
        int a, b;
        cin >> a >> b;
        x -= (a*b);
    }

    (x == 0) ? cout << "Yes" << '\n' : cout << "No" << '\n';
}