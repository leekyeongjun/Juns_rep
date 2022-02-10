#include <iostream>
#include <string>

using namespace std;

int n;


int main()
{
	cin >> n;
	int Max = 0;
	int Min = 8000;
	string elder,youngster;

	for(int i =0; i<n; i++){
		string buf;
		int d, m, y;
		cin >> buf >> d >> m >> y;
		
		int cur = (2010-y)*365 + (12-m)*30 + (31-d);
		if(cur > Max){
			Max = cur;
			elder = buf;
		}
		else if(cur < Min){
			Min = cur;
			youngster = buf;
		}
	}

	cout << youngster << '\n' << elder << '\n';
}
