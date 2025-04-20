#include <iostream>
#include <vector>
#include <stack>
using namespace std;

/*
    DFS(depth first search)는 깊이 우선 탐색으로, 재귀 및 스택을 이용하여 문제를 해결한다.

    1 - 2 - 4
      - 3 - 5
          - 6

    과 같은 자료의 형식이 있을 경우, 탐색 경로는 다음과 같다.

    1. 스택에 다음 행선지를 push
    2. 스택의 top을 pop하며 연결된 노드들을 푸시
    3. 반복

    탐색순서는 1 - 2 - 4 - 3 - 5 - 6 이 된다.
    DFS를 나타내기 위해서는 다음 노드의 인덱스를 가리키는 edge와 
    현재 노드의 데이터를 나타내는 value 값의 구조체가 필요하다.
*/

// 구현



vector<vector <int>> edges;
vector<bool> checker;
stack<int> list;

void DFS(int n){
    if(checker[n]) return;
    checker[n] = true;
    for(int i : edges[n]){
        if(checker[i] == false){
            DFS(i);
        }
    }

};

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int N,K;
    cin >> N >> K;
    checker.resize(N+1, false);
    edges.resize(N+1);

    for(int i = 0; i<K; i++){
        int id, edge;
        cin >> id >> edge;
        edges[id].push_back(edge);
        edges[edge].push_back(id);
    }

    int cnt;
    for(int i = 0; i<N; i++){
        if(!checker[i]){
            cnt++;
            DFS(i);
        }
    }

    cout << cnt << '\n';



}

