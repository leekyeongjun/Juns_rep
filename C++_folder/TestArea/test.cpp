#include <iostream>
#include <queue>

using namespace std;

int N, M, V;

class Node{
	public:
	int data;
	priority_queue<int, vector<int>, greater<int>> edge;	
	bool visit = false;
};

Node arr[1010];
Node arr2[1010];
queue<Node> q;

void DFS(int id){
	//visit
	cout << arr[id].data << " ";
	arr[id].visit = true;
	//move
	while(!arr[id].edge.empty()){
		int tp = arr[id].edge.top();
		if(arr[tp].visit == true){
			arr[id].edge.pop();
		}
		else{
			DFS(tp);
		}
	}
}

void BFS(){
	Node tp = q.front();
	q.pop();
	if(arr2[tp.data].visit ==false){
		arr2[tp.data].visit = true;
		cout << tp.data << " ";
	}
	while(!tp.edge.empty()){
		int ntp = tp.edge.top();
		tp.edge.pop();
		if(arr2[ntp].visit == false){
			q.push(arr2[ntp]);
		}
	}
}

int main()
{	
	ios::sync_with_stdio(false);
	cin.tie(NULL);
	cout.tie(NULL);

	cin >> N >> M >> V;

	for(int i = 1 ; i<=N; i++){
		arr[i].data = i;
		arr2[i].data = i;
	}

	for(int i=1; i<=M; i++){
		int a, b;
		cin >> a >> b;
		arr[a].edge.push(b);
		arr[b].edge.push(a);
		arr2[a].edge.push(b);
		arr2[b].edge.push(a);
	}
	

	DFS(V);
	cout << '\n';

	q.push(arr2[V]);
	while(!q.empty()){
		BFS();
	}
	cout << '\n';
}
