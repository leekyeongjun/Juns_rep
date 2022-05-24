#include <iostream>
#include <algorithm>

using namespace std;
int N;
int nums[1002];
int d[1002];

int DP(int n){
	if(n == 1){
		return d[1];
	}
	else if(d[n] != 0){
//		cout <<"d[" << n <<"] already exist." << '\n';
		return d[n];
	}
	else{
//		cout <<"d[" << n << "] doesn't exist." << '\n';
		int cur = nums[n];
		int s = 1;
		for(int i=1; i<n; i++){
			int tmp;
//			cout << cur << " " << nums[i] << '\n';
			if(cur > nums[i]){
//				cout << "finding DP(" << i << ")..." << '\n';
				tmp = DP(i)+1;
				s = max(s,tmp);
			}
		}
		d[n] = s;
		return d[n];
	}
}


int main()
{
	ios::sync_with_stdio(false);
	cin.tie(NULL);
	cout.tie(NULL);
	cin >> N;
	for(int i = 1; i<= N; i++){
		cin >> nums[i];
	}
	d[1] = 1;
	int S = 1;
	for(int j=1; j<=N; j++){
		S = max(S, DP(j));
	}
	cout << S << '\n';

}
