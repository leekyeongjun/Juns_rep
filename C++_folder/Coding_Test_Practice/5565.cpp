#include <iostream>

using namespace std;



int p;

int main(){
	cin >> p;
	for(int i = 0; i<9; i++){
		int tmp;
		cin >> tmp;
		p -= tmp;
	}
	cout << p << '\n';

}
