#include <iostream>
#include <string>

using namespace std;

string cur, lef;

void printTime(int t){
	if(t == 0){
		cout << "00";
	}
	else if(t < 10){
		cout << "0" << t;
	}
	else{
		cout << t;
	}
}
int main()
{
	cin >> cur >> lef;

	int hour = stoi(lef.substr(0,1)) - stoi(cur.substr(0,1));

	int minute = stoi(lef.substr(3,4)) - stoi(cur.substr(3,4));
	
	int second = stoi(lef.substr(6,7)) - stoi(cur.substr(6,7));

	if(second < 0){
		second += 60;
		minute --;
	}
			
	if(minute < 0){
		minute += 60;
		hour --;
	}

	printTime(hour);
	cout << ":";
	printTime(minute);
	cout <<":";
	printTime(second);
	cout << '\n';


}
