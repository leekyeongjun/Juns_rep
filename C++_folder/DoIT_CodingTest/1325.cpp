#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>

using namespace std;


int main()
{
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int N,M;
    cin >> N >> M;
    vector<vector<int>> coms(N+1);

    for(int i = 0; i<M; i++){
        int end, start;
        cin >> end >> start;
        coms[start].push_back(end);
    }


    //priority_queue<int> pq;
    vector<int> v;

    for(int i = 1; i<= N; i++){
        queue<int> reservation;
        vector<bool> visited(N+1, false);
        int cnt = 0;
        reservation.push(i);

        while(!reservation.empty()){
            int cur = reservation.front();
            reservation.pop();
            visited[cur] = true;
            for(auto i : coms[cur]){
                if(visited[i] == false){
                    cnt++;
                    reservation.push(i);
                }
            }
        }

        v.push_back(cnt);
    }
    
    int max_num = *max_element(v.begin(), v.end());

    for(int i = 0; i<N; i++){
        if(v[i] == max_num){
            cout << i+1 << ' ';
        }
    }
    cout << '\n';
}