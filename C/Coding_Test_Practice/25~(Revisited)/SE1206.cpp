#include <iostream>
#include <algorithm>
using namespace std;

int main() {
    ios::sync_with_stdio(0);
    cin.tie(0); cout.tie(0);

    for (int T = 1; T <= 10; T++) {
        int N;
        cin >> N;
        int arr[1000] = {0,}; // 문제 조건: N <= 1000
        for (int i = 0; i < N; i++) {
            cin >> arr[i];
        }

        int sum = 0;
        for (int i = 2; i < N - 2; i++) {
            int max_left = max(arr[i - 1], arr[i - 2]);
            int max_right = max(arr[i + 1], arr[i + 2]);
            int max_around = max(max_left, max_right);
            if (arr[i] > max_around) {
                sum += arr[i] - max_around;
            }
        }

        cout << "#" << T << " " << sum << '\n';
    }

    return 0;
}
