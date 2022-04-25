#include <iostream>
#include <queue>
using namespace std;

int N,M;
int sx,sy,fx,fy;

int grid[110][110];

typedef struct{
	int x,y;
}coor;

queue<coor> q;

int main()
{
	ios::sync_with_stdio(false);
	cin.tie(NULL);
	cout.tie(NULL);

	cin >> N >> M >> sx >> sy >> fx >> fy;

	q.push({sx,sy});
	// struct can be initialized by {}
	
	//---------solution

	while(!q.empty()){
		auto c = q.front(); //peek
		q.pop();
		
		if(c.x == fx && c.y == fy){
			//popped target!!
			cout << grid[c.x][c.y] << '\n';
		}

		int dx[] = {1,1,-1,-1,2,2,-2,-2};
		int dy[] = {2,-2,2,-2,1,-1,1,-1};
		//move range
		

		for(int i=0; i<8; i++){
			int nx = c.x + dx[i];
			int ny = c.y + dy[i];

			//============== conditions ==================
			if(!(1 <= nx && nx <= N && 1 <= ny && ny <= M ))
				continue;

			if(grid[nx][ny] != 0)
				continue;

			grid[nx][ny] = grid[c.x][c.y]+1;
			q.push({nx,ny});
		}
	}
}

