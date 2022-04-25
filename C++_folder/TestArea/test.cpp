#include <functional>
#include <iostream>
#include <set>
#include <string>
#include <vector>
#include <queue>
using namespace std;

set<string> A;
vector<string> B;

priority_queue<string, vector<string>, greater<string>> ans;

int main()
{
	int N, M;
	cin >> N >> M;

	if(N <= M){
		for(int i= 0 ; i<N; i++){
			string c;
			cin >> c;
			B.push_back(c);	
		}
		for(int j=0; j<M; j++){
			string d;
			cin >> d;
			A.insert(d);
		}
	}
	else{
		for(int i= 0 ; i<N; i++){
			string c;
			cin >> c;
			A.insert(c);	
		}
		for(int j=0; j<M; j++){
			string d;
			cin >> d;
			B.push_back(d);
		}
	}
	int sz = B.size();
	for(int i = 0; i < sz; i++){
		set<string>::iterator it;
		it = A.find(B[i]);
		if(it != A.end()){
			ans.push(*it);
		}
	}

	
	while(!ans.empty()){
		cout << ans.top() << '\n';
		ans.pop();
	}
}


