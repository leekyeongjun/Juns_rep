#include <iostream>
using namespace std;

int T;
int A,B,C;
// 5min = 300sec;
// 1min = 60sec;
// 10sec;
int main()
{
	A = 0; B = 0; C = 0;
	cin >> T;	
	while(T-300>=0){
		A ++;
		T -= 300;
	}
	while(T-60 >= 0){
		B ++;
		T-= 60;
	}
	while(T-10 >= 0){
		C ++;
		T -= 10;
	}

	if(T != 0){
		cout << -1 << '\n';
		return 0;
	}
	else{
		cout << A << " " << B << " " << C << '\n';
	}
}
