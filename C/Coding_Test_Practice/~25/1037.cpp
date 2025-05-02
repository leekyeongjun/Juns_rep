#include <iostream>

using namespace std;

int main(){
    int n, f, l;
    f = 1000000;
    l = -1;

    cin >> n;
    if(n == 1){
        int b;
        cin >> b;
        cout << b*b << '\n';
    }
    else{
        for(int i = 0; i<n; i++){
            int a;
            cin >> a;
            if(a <= f) f = a;
            if(a >= l) l = a;
        }

        cout << f*l << '\n';
    }   

}