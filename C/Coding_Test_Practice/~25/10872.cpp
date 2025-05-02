#include <iostream>

using namespace std;

int factorial(int i)
{
    if (i == 1)
    {
        return i;
    }
    else if (i == 0)
    {
        return 1;
    }
    else
    {
        return i *factorial(i - 1);
    }
}

int main()
{
    int i;
    cin >> i;
    cout << factorial(i) << endl;

}