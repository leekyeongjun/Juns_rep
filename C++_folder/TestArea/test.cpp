#include <iostream>
#include <queue>

using namespace std;
int se,ga;

typedef struct{
	int s, g;
}pos;

int GRID[1010][1010];
int cnt = 0;
queue<pos> q; 

void DFS(){
	//visit
	pos c = q.front();
	q.pop();
	//cout << "[CURRENT POS] : " << c.g << "," << c.s << '\n';
	//traverse
	int Dse[4] = {1,-1,0,0};
	int Dga[4] = {0,0,1,-1};
	for(int k = 0 ; k<4; k++){		
		int ns = c.s+Dse[k];
		int ng = c.g+Dga[k];

		//cout << "checking :" << ng << "," << ns << "\n";
		if(ns >= 0 && ng >= 0 && GRID[ns][ng] == 0){
			GRID[ns][ng] = GRID[c.s][c.g] +1;
			cnt = GRID[ns][ng];
			q.push({ns,ng});
		}
		/*
		for(int i=0; i<se; i++){
			for(int j=0; j<ga; j++){
				cout << GRID[i][j] << " ";
			}	
			cout << '\n';
		}
		cout << "==========================" << '\n';
		*/
	}
}

int main(){

	ios::sync_with_stdio(false);
	cin.tie(NULL);
	cout.tie(NULL);

	memset(GRID, -1, sizeof(GRID));
	cin >> ga >> se;
	bool easy = true;

	for(int i=0; i<se; i++){
		for(int j=0; j<ga; j++){
			cin >> GRID[i][j];
		}
	}
	for(int i=0; i<se; i++){
		for(int j=0; j<ga; j++){
			if(GRID[i][j] == 1){
				q.push({i,j});
			}
		}
	}
	while(!q.empty()){
		DFS();
	}
	/*	
	cout << " ========================== " << '\n';
	for(int i=0; i<se; i++){
		for(int j=0; j<ga; j++){
			cout << GRID[i][j] << " ";
		}
		cout << '\n';
	}
	*/
	for(int i=0; i<se; i++){
		for(int j=0; j<ga; j++){
			if(GRID[i][j] == 0){
				cout << -1 << '\n';
				return 0;
			}
		}
	}
	if(cnt == 0 ){cout << cnt;}
	else{
		cout << cnt-1 << '\n';
	}
}


