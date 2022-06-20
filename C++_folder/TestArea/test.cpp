#include <iostream>
#include <vector>

using namespace std;

int parent[51];

vector<vector<int>> v(51);
vector<int> Truth;

int Find_parent(int a){
	if(parent[a] == a) return a;
	else{ 
		int b = Find_parent(parent[a]);	
		parent[a] = b;
		return b;
	}
}

void Union(int a, int b){
	a = Find_parent(a);
	b = Find_parent(b);

	if(a!=b){
		parent[b] = a;
	}
}

int main(){
	ios::sync_with_stdio(false); cin.tie(NULL); cout.tie(NULL);
	int N,M,T;
	cin >> N >> M >> T;
	
	for(int i = 0; i<T; i++){
		int t;
		cin >> t;
		Truth.push_back(t);
	}

	for(int i = 1; i<N; i++){
		parent[i] = i;
	}

	for(int i=0; i<M; i++){
		int P;
		cin >> P;

		int n,p;
		for(int j=0; j<P; j++){
			if(j >= 1){
				p=n;
				cin >> n;
				Union(p, n);
			}
			else cin >> n;
			v[i].push_back(n);
		}
	}

	for(auto& list : v){
		bool able = false;
		for(auto& person : list){
			if(able) break;
			for(auto& t : Truth){
				if(Find_parent(person)==Find_parent(t)){
					able = true;
					break;
				}
			}
		if(able) M--;
		}
	}
	cout << M << '\n';
}
