#include <iostream>

using namespace std;

int h1[101][101];
int h2[101][101];
int h3[101][101];

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int N,M;
    cin >> N >> M;
    for(int i = 0 ; i < N; i++){
        for(int j = 0; j<M; j++){
            cin >> h1[i][j];
        }
    }
    for(int i = 0 ; i < N; i++){
        for(int j = 0; j<M; j++){
            cin >> h2[i][j];
        }
    }

    for(int i = 0; i<N; i++){
        for(int j = 0; j<M; j++){
            cout <<  h1[i][j]+h2[i][j] << " ";
        }
        cout << '\n';
    }

    
}