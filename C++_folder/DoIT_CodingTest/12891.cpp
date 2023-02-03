#include <iostream>
#include <vector>

using namespace std;
/*
    대충 짜보자

    1. 전체 문자열 길이, 부분 문자열 길이 입력받기
    
    2. 포인터 세팅 (첫번째, (첫번째 + 부분문자열 길이) 번째)

    3. while(마지막 포인터가 문자열 끝으로 갈때 까지){
        문자열이 조건 만족하는지 체크
            만족하면 카운터 하나 늘리기
        첫번째꺼 하나 밀고 그만큼 빼기
        마지막꺼 하나 밀고 그만큼 더하기 --> 슬라이딩 윈도우
    }

*/

class Checker{
public:

    int Anum = 0; // ascii 65 -> 0
    int Cnum = 0; // ascii 67 -> 2
    int Gnum = 0; // ascii 71 -> 6
    int Tnum = 0; // ascii 84 -> 19
};
int S, P, cnt;
Checker checker;
vector<int> v;

void check(int index, bool positive){
    if(positive){
        switch (v[index])
        {
            case 0:
                checker.Anum++;
                break;
            case 2:
                checker.Cnum++;
                break;
            case 6:
                checker.Gnum++;
                break;
            case 19:
                checker.Tnum++;
                break;
            default:
                break;
        }    
    }
    else{
        switch (v[index])
        {
            case 0:
                if(checker.Anum > 0) checker.Anum--;
                break;
            case 2:
                if(checker.Cnum > 0) checker.Cnum--;
                break;
            case 6:
                if(checker.Gnum > 0) checker.Gnum--;
                break;
            case 19:
                if(checker.Tnum > 0) checker.Tnum--;
                break;
            default:
                break;
        }    
    }
}

int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);
    cin >> S >> P;
    v.resize(S);

    for(int i = 0; i<S; i++){
        char a;
        cin >> a;
        v[i] = a - 'A';
    }

    int a,c,g,t;
    cin >> a >> c >> g >> t;

    //first check
    int f = 0;
    int l = P-1;

    for(int i = 0; i<P; i++) check(i,true); 

    while(l<S){
        if(checker.Anum >= a && checker.Cnum >= c && checker.Tnum >= t && checker.Gnum >= g) {
            cnt++;
            
        } 
        check(f, false);
        f++;
        l++;
        check(l, true);   
    }

    cout << cnt << '\n';
}