#include <iostream>

using namespace std;

int sanggeun_Num(int n)
{
    return (n % 10) * 100 + (n % 100 - n % 10) + (n / 100);
    // 100의 자리수를 1의 자리로,
    // 1의 자리수를 100의 자리로 옮겨 상근이 숫자를 만드는 함수
}

int main()
{
    int a, b, ans;
    cin >> a >> b;
    a = sanggeun_Num(a);
    b = sanggeun_Num(b);

    ans = (a > b) ? a : b;
    cout << ans << endl;
}
