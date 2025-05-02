#include <iostream>
#include <stack>
#include <vector>
using namespace std;


/*

    1, 2, 3, 4... 계속 숫자는 올라간다,
    내가 할수 있는 건 pop하냐, push하냐뿐이고, 그건 stack의 맨 위에서만 실행된다.

    ex1)
    4 3 6 8 7 5 2 -> 목표수열

    1. ++++
        [1 2 3 4]
        다음숫자 : 5
    2. --
        [1 2]
        다음숫자 : 5
    3. ++
        [1 2 5 6]
        다음숫자 : 7
    4. -
        [1 2 5]
        다음숫자 : 7
    5. ++
        [1 2 5 7 8]
        다음숫자 : 9
    6. -----
        []
        다음숫자 : 9

        결론 : ++++--++-++-----

    ex2)
    1 2 5 3 4 -> 목표수열
    1. +
        [1]
        다음숫자 : 2
    2. -
        []
        다음숫자 : 2
    3. +
        [2]
        다음숫자 : 3
    4. -
        [0]
        다음숫자 : 3
    5. +++
        [3 4 5]
        다음숫자 : 6
    6. -
        [3 4]
        다음숫자 : 6

    7. NO
        목표하는 숫자 : 3 / 4가 막고있으므로 불가능.

    그럼 어떨때 불가능해지나?
        stack의 맨꼭대기, 즉 top이 목표하는 숫자보다 커져버리면 안된다.

        대충 짜보자
        넣을 수 = 1

        for(input 받은것 하나 당)
            while(stack의 탑 < 내가 목표하는 숫자){
                push(넣을 수)
                넣을 수 ++
            }
            if(내가 목표하는 숫자 == stack의 top) pop
            else if(내가 목표하는 숫자 < stack의 top){
                NO
                실행 종료
            }
        }




*/

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    stack<int> s;
    vector<char> ans;

    int N;
    int c = 1;

    cin >> N;
    for(int i = 0; i<N; i++){
        int buf;
        cin >> buf;

        while(s.empty() || buf >s.top()){
            s.push(c);
            c++;
            ans.push_back('+');
        }
        if(buf == s.top()){
            s.pop();
            ans.push_back('-');
        }
        else if(buf < s.top()){
            cout << "NO" << '\n';
            return 0;
        }
    }

    for(int i =0; i<ans.size(); i++){
        cout << ans[i] << " ";
    }
    cout << '\n';


}