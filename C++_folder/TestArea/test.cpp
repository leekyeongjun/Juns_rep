#include <iostream>

using namespace std;

int arr[11];

int DP(int n){
	if(n == 1) return 1;
	else if(n == 2) return 2;
	else if(n == 3) return 4;

	if(arr[n] != 0) return arr[n];
	else{
		arr[n] = DP(n-1) + DP(n-2) + DP(n-3);
		return arr[n];
	}
}
int main()
{
	int T;
	cin >> T;

	for(int i = 0 ; i < T ; i++){
		int a;
		cin >> a;
		cout << DP(a) << '\n';
	}
}
