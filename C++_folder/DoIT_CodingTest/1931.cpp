#include <iostream>
#include <queue>
#include <vector>

using namespace std;

/*
    정렬 -> 배치
    배치?
    int 끝나는시간

    while(pq가 다 비어있지 않으면)
    {
        회의 cur;

        if(끝나는시간 <= cur.시작시간){
            끝나는시간 = cur.끝나는시간
            cnt++
        }
        cur.pop();
    }
*/

class confess{
public:
    int start = 0;
    int end = 0;
};

struct compare{
    bool operator()(confess a, confess b){
        if(a.end != b.end){
            return a.end >= b.end;
        }
        return a.start > b.start;
    }
};
int main(){
    int N;
    cin >> N;
    vector<bool> onConfess;
    priority_queue<confess, vector<confess>, compare> pq;

    for(int i =0; i<N; i++){
        confess newconfess;
        int s,e;
        cin >> s >> e;

        newconfess.start = s;
        newconfess.end = e;

        pq.push(newconfess);
    }

    int cnt = 0;
    int e_time = 0;

    while(!pq.empty()){
        confess cur = pq.top();
        pq.pop();
        if(cur.start >= e_time){
            e_time = cur.end;
            cnt++;
        }

    }

    cout << cnt << '\n';
}