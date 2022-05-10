#include <iostream>
#include <math.h>
#include <queue>
using namespace std;

int x,y,w,h;
priority_queue<int, vector<int>, greater<int>> q;
int main()
{
	cin >> x >> y >> w >> h;
	q.push(x);
	q.push(y);
	q.push(abs(w-x));
	q.push(abs(h-y));

	cout << q.top() << '\n';
}
