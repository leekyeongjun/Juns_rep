#include <iostream>
#include <stdio.h>
#include <string>

using namespace	std;

int n, p;
string name[101];

int main()
{
	cin >> n;
	for(int j = 0; j<n; j++){
		int tmpC = 0;
		string tmpN;
		cin >> p;
		for(int i = 0; i<p; i++){
			int curC;
			string curN;
			cin >> curC >> curN;
			if(curC >= tmpC){
				tmpC = curC;
				tmpN = curN;
			}
		}
		name[j] = tmpN;
	}

	for(int i = 0; i<101; i++){
		cout << name[i] << '\n';
	}
}

