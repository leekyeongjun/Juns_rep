#include <iostream>
using namespace std;
int main()
{
    int n, temp;
    int counter = 0;
    cin >> n;
    if (n < 10)
    {
        n = n * 10;
    }
    temp = (n % 10) * 10 + ((n / 10) + (n % 10));
    ++counter;
    while (temp != n)
    {
        temp = (temp % 10) * 10 + ((temp / 10) + (temp % 10)) % 10;
        ++counter;
    }
    cout << counter << endl;
}
