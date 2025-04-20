#include <iostream>
#include <queue>

using namespace std;

int GRID[101][101] = {0,};
bool visited[101][101] = {false,};

int N, M;
class pos{
public:
    int se = 0;
    int ga = 0;
};

queue<pos> reservation;

void BFS(){
    //reservation 의 top 빼서 확인
    //GRID 돌기 (상,하,좌,우)
    // 1. GRID안의 값이 0이면 reserv에 안 넣음

    //reservation 다 빌때까지 BFS.
    pos c = reservation.front();
    if(c.se == N && c.ga == M) {
        visited[c.se][c.ga] = true;
        reservation.pop();
        return;
    }
    reservation.pop();
    int cur = GRID[c.se][c.ga];
    visited[c.se][c.ga] = true;

    if(GRID[c.se+1][c.ga] != 0 && !visited[c.se+1][c.ga]){
        GRID[c.se+1][c.ga] = cur+1;
        reservation.push({c.se+1, c.ga});
        //cout << c.se+1 <<" , " << c.ga <<" pushed."; 
    }
    if(GRID[c.se][c.ga+1] != 0 && !visited[c.se][c.ga+1]){
        GRID[c.se][c.ga+1] = cur+1;
        reservation.push({c.se, c.ga+1});
        //cout << c.se <<" , " << c.ga+1 <<" pushed."; 
    }
    if(GRID[c.se-1][c.ga] != 0 && !visited[c.se-1][c.ga]){
        GRID[c.se-1][c.ga] = cur+1;
        reservation.push({c.se-1, c.ga});
        //cout << c.se-1 <<" , " << c.ga <<" pushed."; 
    }
    if(GRID[c.se][c.ga-1] != 0 && !visited[c.se][c.ga-1]){
        GRID[c.se][c.ga-1] = cur+1;
        reservation.push({c.se, c.ga-1});
        //cout << c.se <<" , " << c.ga-1 <<" pushed."; 
    }



}

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);


    
    cin >> N >> M;

    for(int se = 1; se<=N; se++){
        for(int ga = 1; ga<=M; ga++){
            char buf;
            cin >> buf;
            GRID[se][ga] = buf-'0';
        }
    }



    pos S = {1,1};
    reservation.push(S);

    while(!reservation.empty()){
        BFS();
    }
/*
    for(int i = 1; i<=N; i++){
        for(int j = 1; j<=M; j++){
            cout << " " << GRID[i][j] << " ";
        }
        cout << '\n';
    }
*/
    cout << GRID[N][M] << '\n';


}