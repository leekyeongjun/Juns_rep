#include <iostream>
#include <queue>
#include <memory.h>

using namespace std;
int GRID[51][51];

typedef struct{
	int s,g;
}pos;

int main()
{
	while(1){
		memset(GRID, 0, sizeof(GRID));
		int g, s;
		cin >> g >> s ;
		if(g == 0 && s == 0) break;
		queue<pos> q;
		int cnt = 2;

		for(int i=0; i<s; i++){
			for(int j=0; j<g; j++){
				cin >> GRID[i][j];
			}
		}

		for(int i=0; i<s; i++){
			for(int j=0; j<g; j++){
				if(GRID[i][j] == 1){
					q.push({i,j});
					GRID[i][j] = cnt;
					while(!q.empty()){
						pos cp = q.front();
						q.pop();
						int ds[8] = {-1,1,0,0,-1,-1,1,1};
						int dg[8] = {0,0,1,-1,1,-1,-1,1};
						for(int k = 0; k<8; k++){
							int ns = cp.s+ds[k];
							int ng = cp.g+dg[k];
							if(ns >= 0 && ng >= 0 && GRID[ns][ng] == 1){
								GRID[ns][ng] = cnt;
								q.push({ns,ng});
							}
						}
					}
				cnt++;
				}
			}
		}
/*
		for(int i=0; i<s; i++){
			for(int j=0; j<g; j++){
				cout << GRID[i][j] << " ";
			}
			cout << '\n';
		}
*/
		cout <<  cnt-2 << '\n';
	}	
}
