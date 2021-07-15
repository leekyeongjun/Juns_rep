#include <iostream>
using namespace std;
int main() {
    int num;
    cin >> num;

    int next = num;
    int cnt = 0;
    while (true) {
        cnt++;
        next = (next%10)*10 + (next/10 + next%10)%10;

        if (num == next)
            break;
    }
    cout << cnt << endl;
}