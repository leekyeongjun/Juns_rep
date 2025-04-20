#include <iostream>
#include <queue>

using namespace std;

typedef struct{
    int value;
    int se;
    int ga;
}num;

struct compare{
    bool operator()(num& a, num& b){
        return a.value<b.value;
    }
};

int main(){
    ios::sync_with_stdio(0); cin.tie(NULL); cout.tie(NULL);
    priority_queue<num, vector<num>, compare> pq;
    for(int i = 0 ; i < 9; i++){
        for(int j = 0; j < 9; j++){
            num n;
            cin >> n.value;
            n.se = i+1;
            n.ga = j+1;
            pq.push(n);
        }
    }

    cout<< pq.top().value << '\n' << pq.top().se << " " << pq.top().ga << '\n';

}