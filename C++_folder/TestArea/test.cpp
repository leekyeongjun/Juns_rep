#include <iostream>
#include <queue>

using namespace std;

class pos{
	public:
	int s,g;
};

int GRID[101][101];
int N,M;
queue<pos> q;

int main(){
	cin >> N >> M;
	for(int i=0; i<N; i++){
		for(int j=0; j<M; j++){
			char a;
			cin >> a;
			GRID[i][j] = a -'0';
		}
	}

	//(0,0) start, (N-1,M-1)
	
	q.push({0,0});
	GRID[0][0] = 2;

	int ds[4] = {1,-1,0,0};
	int dg[4] = {0,0,1,-1};

	while(!q.empty()){
		pos c = q.front();
		q.pop();
		for(int i=0; i<4; i++){
			pos n = {c.s+ds[i], c.g+dg[i]};
			if(n.s >= 0 && n.g >= 0 && n.s < N && n.g < M){
				if(GRID[n.s][n.g] == 1){
					GRID[n.s][n.g] = GRID[c.s][c.g] + 1;
					q.push(n);
				}
			}
		}	
	}

	cout << GRID[N-1][M-1] -1 << '\n';
}
