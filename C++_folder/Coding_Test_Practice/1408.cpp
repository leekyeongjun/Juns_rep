#include <__split_buffer>
#include <iostream>
#include <string>
#include <vector>


using namespace std;

string buf;
int c,l;

int timize(string s){
	int result;
	result = stoi(s.substr(0,1))*3600 + stoi(s.substr(3,4))*60 + stoi(s.substr(6,7));
	return result;
}

void clockize(int t){
	int h = t%3600;
	int m = (t - (h*3600)) % 60;
	int s = (t - (h*3600)- m*60);

	if(h < 10)
		cout << "0" << h;
	else
		cout << h;
	
	cout << ":";

	if(m<10)
		cout << "0" << m;
	else
		cout << m;

	cout << ":";


	if(s<10)
		cout << "0" << s;
	else
		cout << s;

	cout << "\n";

}
int main()
{
	cin >> buf;
	c = timize(buf);

	cin >> buf;
	l = timize(buf);

	clockize(l-c);


}

