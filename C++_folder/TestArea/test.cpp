#include <iostream>

using namespace std;

long long f[1001] = {0,1,2};

long long DP(long long n){
	if(n == 1) return 1;
	else if(n == 2) return 2;
	else if(f[n] != 0) return f[n];
	else{
		f[n] = (DP(n-1) + DP(n-2)) % 10007;
		return f[n];
	}
}

int main()
{
	long long a;
	cin >> a;
	cout << DP(a) << '\n';

}
