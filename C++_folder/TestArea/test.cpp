#include <iostream>
#include <queue>
#include <memory.h>
#include <vector>

using namespace std;

class pos{
	public:
	int s, g;
};

int GRID[1001][1001];
priority_queue<int> pq;

int main()
{
	int N,M;
	vector<pos> walls;
	walls.push_back({-1,-1});

	cin >> N >> M;
	for(int i = 0 ; i<N; i++){
		for(int j = 0; j<M; j++){
			char data;
			cin >> data;
			GRID[i][j] = data - '0';
			if(data - '0' == 1){
				walls.push_back({i,j});
			}
		}
	}
	/*
	for(int i = 0; i<N; i++){
		for(int j=0; j<M; j++){
			cout << GRID[i][j] << " ";
		}
		cout << '\n';
	}
	cout << '\n';
	*/
	for(int i = 0; i<walls.size(); i++){
		pos breakable = walls[i];
		int m = 2;

		int G[1001][1001];
		int ds[4] = {1,-1,0,0};
		int dg[4] = {0,0,1,-1};

		queue<pos> q;
		
		memcpy(G, GRID, sizeof(GRID));
		if(breakable.s != -1 && breakable.g != -1){
			//cout << "break wall : " << breakable.s << " , " << breakable.g << '\n';
			G[breakable.s][breakable.g] = 0;
		}
		//else cout << "unbreakable" << '\n';

		
		G[0][0] = m;
		q.push({0,0});

		while(!q.empty()){
			pos c = q.front();
			q.pop();
			if(c.s == N-1 && c.g == M-1) break;	
			for(int j = 0 ; j<4; j++){
				pos n = {c.s+ds[j], c.g+dg[j]};
				if(n.s >= 0 && n.g >= 0 && n.s < N && n.g < M){
					if(G[n.s][n.g] == 0){
						G[n.s][n.g] = m;
						q.push(n);
					}
				}
			}
			m++;
		}
		/*
		for(int k=0; k<N;k++){
			for(int p=0; p<M; p++){
				cout << G[k][p] << " ";
			}
			cout << '\n';
		}
		cout << '\n';
		*/
		if(G[N-1][M-1] != 0){
			//cout << "minimum breakthrough is " << G[N-1][M-1] -2 << '\n';
			pq.push(G[N-1][M-1] - 2);
		}
	}

	if(!pq.empty()) cout << pq.top() << '\n';
	else cout << -1 << '\n';
}


