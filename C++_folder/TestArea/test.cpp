#include <iostream>
#include <queue>
#include <memory.h>

using namespace std;
class pos{
	public:
		int s,g;
};

int GRID[301][301];
int I;

int dg[8] = {2,2,1,1,-2,-2,-1,-1};
int ds[8] = {1,-1,2,-2,1,-1,2,-2};



int main()
{	
	ios::sync_with_stdio(false);
	cin.tie(NULL);
	cout.tie(NULL);
	int N;
	cin >> N;

	for(int n = 0; n<N; n++){
		memset(GRID, -1, sizeof(GRID));
		queue<pos> q;
		cin >> I;
		for(int i = 0 ; i<I; i++){
			for(int j=0; j<I; j++){
				GRID[i][j] = 0;
			}
		}

		pos cp,dp;
		cin >> cp.s >> cp.g >> dp.s >> dp.g;
		
		GRID[cp.s][cp.g] = 1;

		q.push(cp);

		while(!q.empty()){
			pos cur = q.front();
			q.pop();
			if(cur.s == dp.s && cur.g == dp.g) break;

			for(int i=0; i<8; i++){
				pos np = {cur.g+dg[i], cur.s+ds[i]};
				if(np.g >= 0 && np.s >= 0 && GRID[np.s][np.g] == 0){
					GRID[np.s][np.g] = GRID[cur.s][cur.g] + 1;
					q.push(np);
				}
			}
		}

		cout << GRID[dp.s][dp.g] -1 << '\n';
		}
}



