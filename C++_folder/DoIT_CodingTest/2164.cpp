#include <deque>
#include <iostream>

using namespace std;

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    deque<int> dq;
    int top_card;

    int N;
    cin >> N;
    for(int i = 1; i<=N; i++){
        dq.push_back(i);
    }

    while(!dq.empty()){
        top_card = dq.front();
        dq.pop_front();
        if(dq.empty()) break;
        top_card = dq.front();
        dq.pop_front();
        dq.push_back(top_card);
    }

    cout << top_card << '\n';
}