#include <iostream>
#include <deque>
#include <vector>
using namespace std;


/*
    L = 3

    i = 1
    window = (-3~1) -> (0~1)
    1 5 2 3 6 2 3 7 3 5 2 6
    [ ]
    1

    i = 2
    window = (-2~2) -> (0~2)
    1 5 2 3 6 2 3 7 3 5 2 6
    [   ]
    1

    i = 3
    window = (-1~3) -> (0~3)
    1 5 2 3 6 2 3 7 3 5 2 6
    [     ]
    1

    i = 4
    window = (1~4) (Go)
    1 5 2 3 6 2 3 7 3 5 2 6
      [     ]
    2

    i = 5
    window = (2~5) (GO)
    1 5 2 3 6 2 3 7 3 5 2 6
        [     ]
    2
    ...

    대충 짜보자
    
    1. 첫번째거는 비교 대상이 없으니까 걍 출력
    2. 두번째거 넣어봐

        마지막거보다 작아?
            yes -> 지금거보다 작은 애 나올때 까지 빼 다 비었으면 멈춰야된다?
            no -> 마지막에 붙어

        인덱스 초과해?
            yes -> 맨앞에거 빼
            no -> 넘어가


    3. 맨앞에거는 항상 제일 작은 값이니까, 출력하면 정답!


*/

class node{
public:
    int value = 0;
    int index = 0;
};

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int N, L;
    int index_size = 0;

    deque<node> dq;
    vector<int> v;

    cin >> N >> L;
    for(int i = 0; i<N; i++){
        node cur;
        cin >> cur.value;
        cur.index = i;

        if(cur.index == 0){
            dq.push_back(cur);
        }
        else{
            while(!dq.empty() && dq.back().value > cur.value){
                dq.pop_back();
            }
            dq.push_back(cur);
            index_size = dq.back().index -dq.front().index;

            while(index_size >= L){
                dq.pop_front();
                index_size = dq.back().index -dq.front().index;
            }
        }
        v.push_back(dq.front().value);
    }

    for(int i=0; i<v.size(); i++){
        cout << v[i] << " ";
    }
    cout << '\n';

    
}