#include <iostream>
#include <string>
using namespace std;
int main()
{
    int a;
    string b;
    cin >> a >> b;
    for (int i = 0; i < 3; i++)
    {
        cout << a * (b.at(2 - i) - '0') << endl;
    }
    cout << a * stoi(b) << endl;
    return 0;
}

