#include <iostream>
#include <string>

using namespace std;

int n;


int main()
{
	cin >> n;
	int Max = 0;
	int Min = 2000000;
	string elder,youngster;

	for(int i =0; i<n; i++){
		string buf;
		int d, m, y;
		cin >> buf >> d >> m >> y;
		
		int cur = (y*365) + (m*30) + d;
		if(cur > Max){
			Max = cur;
			youngster = buf;
		}
		else if(cur < Min){
			Min = cur;
			elder = buf;
		}
	}

	cout << youngster << '\n' << elder << '\n';
}
