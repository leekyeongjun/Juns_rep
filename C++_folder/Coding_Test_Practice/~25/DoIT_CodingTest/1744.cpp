#include <iostream>
#include <queue>

using namespace std;

/*
-1 -8 2 1 3 6 -5 0 1

    양수 {6 3 2 1 1}

    음수 {-8 -5 -1}

    0 1개

    대충짜보자
     양수 -> 큰순 정렬해
        두개 빼서 곱해봐
            2보다 커? 그럼 고
            2보다 작거나 깉아? 그럼 따로 더헤
     
        숫자가 남아? 그럼 걍 싹 더해

     음수 -> 작은 순 정렬해
        두개 빼서 곱해봐
            고

        숫자가 남아? 0개수 하나씩 줄여가면서 뺴
        그래도 남아? 그럼 어쩔수 없지 더해
*/
priority_queue<int> pq_plus;
priority_queue<int, vector<int>, greater<int>> pq_minus;

int zero = 0;

int main(){
    int N;
    cin >> N;

    for(int i = 0; i<N; i++){
        int a;
        cin >> a;
        if(a > 0) pq_plus.push(a);
        else if(a < 0)pq_minus.push(a);
        else zero++;
    }

    int sum = 0;

    while(pq_plus.size() != 1){
        int f,s;
        f = pq_plus.top();
        pq_plus.pop();
        s = pq_plus.top();
        pq_plus.pop();

        if(f*s > 2){
            sum += (f*s);
        }
        else{
            sum += f + s;
        }
    }

    if(!pq_plus.empty()){
        sum += pq_plus.top();
        pq_plus.pop();
    }

    while(pq_minus.size() > 1){
        int f,s;
        f = pq_minus.top();
        pq_minus.pop();
        s = pq_minus.top();
        pq_minus.pop();

        sum+= (f*s);
    }

    if(!pq_minus.empty()){
        if(zero == 0){
            sum += pq_minus.top();
        } 
    }
    cout << sum << '\n';
}