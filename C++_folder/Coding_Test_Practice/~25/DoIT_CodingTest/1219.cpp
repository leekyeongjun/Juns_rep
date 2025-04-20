/* 벨만 포드 
    그래프탐색 알고리즘에서, 최단거리를 구하는 알고리즘으로 음수 가중치 에지가 있어도 수행가능함.
    가중치가 전부 양수여야 했던 다익스트라와는 달리 음수 사이클의 존재여부도 확인할 수 있음.

    1. 정답배열의 출발 노드는 0, 나머지 노드는 무한대로 초기화.
    
    2. 모든 에지를 확인하기
        1) N개의 노드가 있는 그래프에서, 두 노드의 최단거리를 구성할 수 있는 에지의 최대 개수는 N-1이다.
        2) 에지 = {출발, 종료, 가중치} 라고 했을때,

            출발 지점의 정답배열값 != 무한대 &&
            종료지점의 정답 배열값 > 출발지점의 정답배열값 + 가중치 일때,
            종료지점의 정답 배열값 = 출발지점의 정답 배열값 + 가중치로 업데이트.
            -> 최단 거리로 업데이트 하는 다익스트라와 유사함.

    3. 음수 사이클 확인하기
        1) 모든 에지를 N-1번 확인 이후, 한번 더 확인함
        2) 이때 업데이트 되는 노드가 있으면 이는 음수사이클이 있는 것이므로 최단거리가 무의미함.
*/

#include <iostream>
#include <vector>
#include <limits.h>
#include <queue>

typedef struct
{
    int _start;
    int _end;
    int _weight;
}edge;


using namespace std;
int main(){
    ios::sync_with_stdio(0); cin.tie(NULL); cout.tie(NULL);
    int N, START, END, M;
    cin >> N >> START >> END >> M;
    
    vector<long> income(N);
    vector<edge> edges;
    vector<long> minDist(N, LONG_MIN);

    for(int i = 0 ; i < M; i++){
        int s, e, w;
        cin >> s >> e >> w;
        edge tmpedge = {s,e,w};
        edges.push_back(tmpedge);
    }

    for(int i = 0; i<N; i++){
        cin >> income[i];
    }

//벨만포드 실행

    minDist[START] = income[START];

    for(int i =0; i<=N+55; i++){
        for(int j = 0; j<M; j++){
            edge e = edges[j];
            if(minDist[e._start] == LONG_MIN){
                continue;
            }
            else if(minDist[e._start] == LONG_MAX){
                minDist[e._end] = LONG_MAX;
            }
            else if(minDist[e._end] < minDist[e._start]+income[e._end] - e._weight){
                minDist[e._end] = minDist[e._start]+ income[e._end] - e._weight;
                if(i>= N-1){
                    minDist[e._end] = LONG_MAX;
                }
            }
        }
    }


    if(minDist[END] == LONG_MIN) {
        cout << "gg" << '\n';
    }
    else if(minDist[END] == LONG_MAX) {
        cout << "Gee" << '\n';
    }
    else{
        cout<<minDist[END] << '\n';
    }
}