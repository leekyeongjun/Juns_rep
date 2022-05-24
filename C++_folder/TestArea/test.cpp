#include <iostream>
#include <queue>
#include <vector>
#include <memory.h>
#include <algorithm>

using namespace std;

class pos{
	public:
	int s,g;

};

int GRID[10][10];
int G[10][10];

pos wall[100];
int posn = 0;

int N,M;

priority_queue<int> pq;
queue<pos> q;

int main()
{
	memset(GRID, -1, sizeof(GRID));
	cin >> N >> M;
	for(int i = 0 ; i<N; i++){
		for(int j =0; j<M; j++){
			cin >> GRID[i][j];
			if(GRID[i][j] == 0){
				wall[posn] = {i,j};
				posn++;
			}
		}
	}

	//1, set walls
	for(int i=0; i<posn; i++){
		for(int j=0; j<i; j++){
			for(int k=0; k<j; k++){
				int dg[4] = {1,-1,0,0};
				int ds[4] = {0,0,1,-1};

				memcpy(G, GRID, sizeof(GRID));
				pos p1 = wall[i];
				pos p2 = wall[j];
				pos p3 = wall[k];
				G[p1.s][p1.g] = 1;
				G[p2.s][p2.g] = 1;
				G[p3.s][p3.g] = 1;

	//2. DO BFS.
				for(int n = 0; n<N; n++){
					for(int m=0; m<M; m++){
						if(G[n][m] == 2) q.push({n,m});				
					}
				}

				while(!q.empty()){
					pos c = q.front();
					q.pop();
					for(int p=0; p<4; p++){
						pos np;
						np.s = c.s+ds[p];
						np.g = c.g+dg[p];
						if(np.s >= 0 && np.g >= 0 && G[np.s][np.g] == 0){
							G[np.s][np.g] = 2;
							q.push(np);
						}
					}
				}
//3.count and add to pq.
				int cnt=0;
				for(int n=0; n<N; n++){
					for(int m=0; m<M; m++){
						if(G[n][m] ==0){
							cnt++;
						}
					}
				}
				pq.push(cnt);
			}	
		}	
	}

//4. print it.
	cout << pq.top() << '\n';

}
