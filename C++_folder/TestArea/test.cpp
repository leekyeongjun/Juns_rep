#include <algorithm>
#include <iostream>
#include <queue>

using namespace std;

class Node{
	public:
	int data = 0 ;
	queue<int> edge;
};

int init_data = 1;
int ans = 0;
queue<Node> q;

int N, M;
Node nd[1010];
int nddt[1010];

int main(){
	ios::sync_with_stdio(false);
	cin.tie(NULL);
	cout.tie(NULL);

	cin >> N >> M;
	for(int i = 0 ; i < M; i++){
		int a, b;
		cin >> a >> b;
		nd[a].edge.push(b);
		nd[b].edge.push(a);
	}

	for(int i = 1 ; i<= N; i++){
		if(nd[i].data == 0 && !nd[i].edge.empty()){
			nd[i].data = init_data;
			q.push(nd[i]);
			while(!q.empty()){
				Node cur = q.front();
				q.pop();
				while(!cur.edge.empty()){
					if(nd[cur.edge.front()].data == 0){
						q.push(nd[cur.edge.front()]);
						nd[cur.edge.front()].data = init_data;
					}
					cur.edge.pop();
				}
			}
			init_data ++;
		}
	}

	for(int i = 1 ; i<=N; i++){
		int c = nd[i].data;
		nddt[c]++;
	}
	for(int i = 0; i<1010; i++){
		if(nddt[i] != 0){
			ans += nddt[i];
		}
	}
	cout << ans << '\n';
}

