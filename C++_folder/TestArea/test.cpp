#include <iostream>

using namespace std;
long long N;
int main()
{
	ios::sync_with_stdio(false);
	cin.tie(NULL);
	cout.tie(NULL);

	cin >> N;
	// 1 2ea
	// 2 3ea
	// 3 4ea
	// ...
	// 11 222 3333 44444 555555 6666666 ...
	
	long long cnt = 2;

	while(N > 0){
		N -= cnt;
		cnt ++;
	}

	cout << cnt-2 << '\n';
	

}
