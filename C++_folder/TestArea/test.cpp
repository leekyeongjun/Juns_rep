#include <functional>
#include <iostream>
#include <memory.h>
#include <queue>

using namespace std;
class pos{
	public:
		int s,g;
};

int GRID[101][101];
int CHECK[101][101];
priority_queue<int> pq;
int main()
{
	ios::sync_with_stdio(false);
	cin.tie(NULL);
	cout.tie(NULL);

	int N;
	
	cin >> N;
	int max = -1;
	for(int i = 0 ; i < N; i++){
		for(int j = 0 ; j< N; j++){
			int a;
			cin >> a;
			if(a > max) max = a;
			GRID[i][j] = a;
		}
	}
	
	for(int i = 0; i< max; i++){
		//dfs
		memset(CHECK, 0, sizeof(CHECK));
		queue<pos> q;
		int cnt = 1;
		for(int se = 0 ; se<N; se++){
			for(int ga = 0; ga < N; ga++){
				if(GRID[se][ga] > i && CHECK[se][ga] == 0){
					q.push({se,ga});
					CHECK[se][ga] = cnt;

					while(!q.empty()){
						pos c = q.front();
						q.pop();

						int ds[4] = {-1,1,0,0};
						int dg[4] = {0,0,-1,1};

						for(int m=0; m<4; m++){
							pos n = {c.s+ds[m], c.g+dg[m]};
							if(n.s >= 0 && n.g >= 0 && n.s < N && n.g < N){
								if(GRID[n.s][n.g] > i && CHECK[n.s][n.g] == 0){
									CHECK[n.s][n.g] = cnt;
									q.push(n);
								}
							}
						}
					}
					cnt++;
				}
			}
		}
		/*
		 * Testing
		for(int se = 0 ; se < N; se ++){
			for(int ga = 0; ga < N ; ga ++){
				cout << CHECK[se][ga] << " ";
			}
			cout << '\n';
		}
		cout << "++++++++++++++++++++++++" << '\n';
		*/
		pq.push(cnt-1);
	}
	cout << pq.top() << '\n';
}
