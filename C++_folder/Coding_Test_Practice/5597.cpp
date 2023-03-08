#include <iostream>
#include <vector>

using namespace std;

int main()
{
    vector<bool> s(31, false);
    for(int i = 0; i<30; i++){
        int a;
        cin >> a;
        s[a] = true;
    }

    for(int i = 1; i<= 30; i++){
        if(!s[i]) cout << i << '\n';
    }
}