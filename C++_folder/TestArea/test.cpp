#include <iostream>
using namespace std;

int n;
int cnt = 0;

int money[6] = {500,100,50,10,5,1};

void CutBucks(int id){
//	cout << "Doing.. " << money[id] << " ..." << '\n'; 
	int cut = money[id];
	if(n >= cut){
//		cout << n << " - " << cut*(n/cut) << " ..." << '\n';
		cnt += n/cut;
		n -= cut*(n/cut);
//		cout << "cnt is " << cnt << '\n';
	}
}

int main()
{
	ios::sync_with_stdio(false);
	cin.tie(NULL);
	cout.tie(NULL);
	
	int a;
	cin >> a;
	n = 1000-a;
	
	for(int i = 0; i<6; i++){
		CutBucks(i);
	}
	cout << cnt << '\n';
}
