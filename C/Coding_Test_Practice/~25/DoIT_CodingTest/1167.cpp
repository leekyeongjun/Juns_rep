#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>

using namespace std;


/*
    각 노드에서 BFS
        -더하는 과정에서 가중치 추가해줌

    트리의 지름
    -->왔다
    <--갔다 했을때 제일 큰거
*/

class node{
public:
    vector<pair<int,int>> edges;
    bool visited = false;
};

vector<node> nodes;
queue<int> reservation;
vector<int> dist;

void BFS(){
    while(!reservation.empty()){
        //뺘면서방문
        int cur = reservation.front();
        reservation.pop();

        if(nodes[cur].visited == false){
            nodes[cur].visited = true;
            for(auto i : nodes[cur].edges){
                if(!nodes[i.first].visited){
                    reservation.push(i.first);
                    dist[i.first] = dist[cur]+i.second;
                }
            }
        }
    }
}

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);


    int N;
    cin >> N;

    nodes.resize(N+1);
    dist.resize(N+1);

    for(int i = 0 ; i < N; i++){
        int id;
        cin >> id;
        int buf = 0;
        while(1){
            cin >> buf;
            if(buf == -1) break;
            else{
                int weight;
                cin >> weight;
                nodes[id].edges.push_back({buf,weight});
                nodes[buf].edges.push_back({id,weight});
            }
        }
    }

    for(int i = 0; i<=N; i++){
        nodes[i].visited = false;
        dist[i] = 0;
    }

    reservation.push(1);
    BFS();

    int max_index = max_element(dist.begin(), dist.end()) - dist.begin();

    for(int i = 0; i<=N; i++){
        nodes[i].visited = false;
        dist[i] = 0;
    }

    reservation.push(max_index);
    BFS();

    int maxnum = *max_element(dist.begin(), dist.end());
    cout << maxnum << '\n';
    

        
}
