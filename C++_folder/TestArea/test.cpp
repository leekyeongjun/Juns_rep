#include <functional>
#include <iostream>
#include <queue>

using namespace std;

priority_queue<int> q1;
priority_queue<int, vector<int>, greater<int>> q2;

int main()
{
	int sum = 0;
	int n;
	cin >> n;

	for(int i = 0 ; i <n; i++){
		int a;
		cin >> a;
		q2.push(a);
	}

	for(int i=0; i<n; i++){
		int b;
		cin >> b;
		q1.push(b);
	}

	while(!q1.empty() && !q2.empty()){
		sum += q1.top()*q2.top();
		q1.pop();
		q2.pop();
	}
	cout << sum << '\n';
}
