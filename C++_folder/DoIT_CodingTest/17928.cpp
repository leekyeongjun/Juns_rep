#include <iostream>
#include <stack>
#include <vector>
/*

1.
    3
    ^
    ?

2.
    5 3
    ^ ^
    ? 5

3.
    2 5 3
    ^ ^ ^
    ? ? 5

4.
    7 2 5 3
    ^ ^ ^ ^
    ? 7 7 5

    대충짜보자
    value와 index값을 가진 class이용,

    1. stack하나, vector하나 만들기
    2. Input받기
        stack이 비어있다 -> stack에 넣기, vector[index] = -1로 초기화
        stack에 뭔가 있다
            stack.top()과 Input의 value 비교
                stack.top()이 더 크다 stack에 넣기, vector[index] = -1로 초기화
                while(Input이 더 크다){
                    vector[stack.top.index]값은 Input.value
                    stack.pop();
                    다빠지면 break;
                }

    3. 
*/


using namespace std;




class Node{
public:
    int value = 0;
    int index = 0;
};

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    stack<Node> s;

    int N;
    cin >> N;

    vector<int> ans(N,-1);

    for(int i = 0; i<N; i++){
        Node n;
        cin >> n.value;
        n.index = i;

        if(s.empty()){
            s.push(n);
        }
        else{            
            while(s.top().value < n.value){
                ans[s.top().index] = n.value;
                s.pop();
                if(s.empty()) break;
            }
            if(s.empty()) s.push(n);
            else if(s.top().value >= n.value) s.push(n);
        }
    }

    for(int j=0; j<N; j++){
        cout << ans[j] << ' ';
    }
    cout << '\n';
}