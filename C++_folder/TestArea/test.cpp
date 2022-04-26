#include <iostream>
#include <queue>

using namespace std;
struct compare{
	bool operator()(pair<int,int> a, pair<int,int> b){
		if(a.first == b.first)
			return a.second > b.second;
		return a.first > b.first;
	}
};

priority_queue<pair<int,int>, vector<pair<int,int>>, compare> pq;

int main()
{
	int N;
	cin >> N;
	for(int i = 0 ; i<N; i++){
		int a;
		cin >> a;
		if(a != 0){
			pq.push({abs(a), a});
		}
		else{
			if(pq.empty()){
				cout << "0" << '\n';
			}
			else{
				cout << pq.top().second << '\n';
				pq.pop();
			}
		}
	}


}
