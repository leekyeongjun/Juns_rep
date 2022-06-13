#include <iostream>
#include <queue>
using namespace std;

int N;
priority_queue<int, vector<int>, greater<int>> pq;
int main(){
	ios::sync_with_stdio(false); cin.tie(NULL); cout.tie(NULL);
	cin >> N;

	for(int i = 0; i<N; i++){int a; cin >> a; pq.push(a);}
	int cnt = 0;
	int sum = 0;
	int ans = 0;

	while(!pq.empty()){
		sum += pq.top();
		ans += pq.top();
		pq.pop();
		cnt++;
		/*
		cout << "current Sum is " << sum << '\n';
		cout << "current Ans is " << ans << '\n';
		*/
		if(pq.empty()) break;
		else if(cnt == 2){
			pq.push(sum);
			sum = 0;
			cnt = 0;
		}
	}

	cout << ans << '\n';


}
