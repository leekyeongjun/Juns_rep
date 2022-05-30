#include <iostream>
using namespace std;

int ppl[51];
int grid[51][51];

int N, M, K;
int cnt = 0;

int main()
{
	ios::sync_with_stdio(false);
	cin.tie(NULL);
	cout.tie(NULL);

	cin >> N >> M;
	cin >> K;

	for(int i = 0 ; i<K; i++){
		int a;
		cin >> a;
		ppl[a] = 1;
	}

	int b;
	for(int i = 0 ; i<M; i++){
		bool t = false;
		cin >> b;
		for(int j=0; j<b; j++){
			int cur;
			cin >> cur;
			grid[i][j] = cur;
			if(ppl[cur] == 1){
				t = true;
			}
		}
		if(t){
			for(int k = 0; k<b; k++){
				ppl[grid[i][k]] = 1;
			}
		}		
	}

	for(int i=0; i<M; i++){
		if(ppl[grid[i][0]]==0){
			cnt++;
		}
	}

	cout << cnt << '\n';
}
