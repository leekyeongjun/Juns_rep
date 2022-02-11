#include <iostream>

using namespace std;


int fi(int a){
	if(a <= 1){
		return a;
	}
	return fi(a-1)+ fi(a-2);
}

int main()
{
	int n;
	cin >> n;
	cout << fi(n);
}
