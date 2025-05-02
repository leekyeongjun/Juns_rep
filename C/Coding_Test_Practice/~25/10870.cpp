#include <iostream>
#include <vector>

using namespace std;

int main()
{
    int Fibonacci[20];
    Fibonacci[0] = 0;
    Fibonacci[1] = 1;
    // dirty
    
    int command;
    cin >> command;

    for (int count = 2; count < command + 2; count++)
    {
        Fibonacci[count] = Fibonacci[count - 1] + Fibonacci[count - 2];
    }

    cout << Fibonacci[command];
}