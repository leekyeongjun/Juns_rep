#include <iostream>
#include <vector>
#include <queue>


using namespace std;

/*

    A리터   B리터   C리터
    0      0      C

    물의 양 이동
    -> C의 양이 0이 되거나
    -> A or B의 양이 풀이되거나.

    A가 비었을때, C에 있을 수 있는 물의 양을 모두 출력

    경우의 수
    A - C
    A - B
    B - A
    B - C
    C - A
    C - B


*/
int send[] = {0,0,1,1,2,2};
int reci[] = {1,2,0,2,0,1};

int main(){
    int Bottle[3];
    bool visited[201][201];
    bool answer[201];
    cin >> Bottle[0] >> Bottle[1] >> Bottle[2];
    
    // 0 : A | 1 : B | 2 : C

    queue<pair<int,int>> status;
    status.push({0,0});
    visited[0][0] = true;
    answer[Bottle[2]] = true;

    while(!status.empty()){
        pair<int,int> cur = status.front();
        status.pop();
        int A = cur.first;
        int B = cur.second;
        int C = Bottle[2] - A - B;

        for(int i = 0; i<6; i++){
            int next[] = {A,B,C};
            next[reci[i]] += next[send[i]];
            next[send[i]] = 0;

            if(next[reci[i]]>Bottle[reci[i]]){
                next[send[i]] = next[reci[i]] - Bottle[reci[i]];
                next[reci[i]] = Bottle[reci[i]];
            }

            if(!visited[next[0]][next[1]]){
                visited[next[0]][next[1]] = true;
                status.push({next[0],next[1]});
            }

            if(next[0] == 0){
                answer[next[2]] = true;
            }
        }

    }



    for(int i = 0; i<201; i++){
       if(answer[i]) cout << i << ' ';
    }
    cout << '\n';
}