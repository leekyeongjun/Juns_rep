#include <iostream>

using namespace std;
int G[1025][1025] = {0,};
int SG[1025][1025] = {0,};
int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int N, M;


    cin >> N >> M;


    for(int se = 1; se<=N; se++){
        for(int ga = 1; ga<=N; ga++){
            cin >> G[se][ga] ;
        }
    }

    //부분합 구하기
    for(int se = 1; se <= N; se++){
        for(int ga = 1; ga <= N; ga++){
            SG[se][ga] = SG[se][ga-1] + SG[se-1][ga] - SG[se-1][ga-1] + G[se][ga];
        }
    }


   //답하기
   for(int i = 0; i<M; i++){
        int x1,y1, x2,y2;
        cin >> x1 >> y1 >> x2 >> y2;
        int r = SG[x2][y2] - SG[x1-1][y2] -SG[x2][y1-1]+ SG[x1-1][y1-1];
        cout << r << '\n';
   }
}