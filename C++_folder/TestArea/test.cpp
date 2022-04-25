#include <iostream>
#include <memory.h>

using namespace std;


int Farm[60][60];
int ans = 0;
int ga,se,ra;
void DFS(int g, int s){
	Farm[g][s] = ans + 2;
	int dx[] = {0,0,1,-1};
	int dy[] = {1,-1,0,0};

	for(int i = 0; i< 4; i++){
		int ng = g+dx[i];
		int ns = s+dy[i];
		if(Farm[ng][ns] == 1 && ng >= 0 && ns >= 0 && ng < ga && ng < se){
			DFS(ng,ns);
		}
	}

}

int main(){
	int T;
	cin >> T;
	for(int I = 0; I< T; I++){
		ans = 0;
		memset(Farm, 0, sizeof(Farm));
		ga = 0;
		se = 0;
		ra = 0;
		cin >> ga >> se >> ra;
		for(int i = 0 ; i < ra; i++){
			int rga, rse;
			cin >> rga >> rse;
			Farm[rse][rga] = 1;
		}

		for(int i = 0 ; i < se; i++){
			for(int j= 0 ; j<ga; j++){
				cout << Farm[i][j]<< " ";
			}
			cout << '\n';
		}
		cout << '\n';
		
		for(int i = 0 ; i <se; i++){
			for(int j= 0 ; j<ga; j++){
				if(Farm[i][j] == 1){
					DFS(i,j);
					ans++;
				}
			}
		}


		for(int i = 0 ; i < se; i++){
			for(int j= 0 ; j<ga; j++){
				cout << Farm[i][j]<< " ";
			}
			cout << '\n';
		}
		cout << ans << '\n';
	}
}
