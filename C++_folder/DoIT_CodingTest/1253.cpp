#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;
/*
    1 2 3 4 5 6 7 8 9 10 : 고른 숫자 1 - 자리 없음
    ^ 

    1 2 3 4 5 6 7 8 9 10 : 고른 숫자 2 - 자리 없음
      ^

    1 2 3 4 5 6 7 8 9 10 : 고른 숫자 3 - 자리 있음
    f l ^

    1 2 3 4 5 6 7 8 9 10 : 고른 숫자 4 - 자리 있음
    f   l ^

*/

/* 대충 짜보자

    1. 입력받아서 벡터에 넣기
    2. 벡터 정렬하기
    3. 포인터 두개 위치설정하기
        case 1 남는 칸이 없다 -> 넘겨
        case 2 남는 칸이 2개 이상 있다 -> 0번째 수 ~ (고른 인덱스 -1)번째 수 두개 설정
    4. 투포인터 돌리기
        while(left < right){
            case 1 left+right가 고른 숫자임 -> 성공했으니까 break
            case 2 left+right가 고른 숫자보다 작음 -> left++
            case 3 left+right가 고른 숫자보다 큼 -> right--
        }


*/


int main()
{

    int N;
    int cnt = 0; // 답변수
    cin >> N;
    vector<int> v(N);
    for(int i=0; i<N; i++) cin >> v[i]; //1
    sort(v.begin(), v.end()); //2
    
    for(int i = 0; i<N; i++){ //3
        int f = 0;
        int l = N-1; // 3
        long target = v[i]; // ! 숫자 짱클수도 있다

        while(f<l){ // 4 
            if(v[f]+v[l] == target){
                if(f != i && l != i){
                    cnt++; 
                    break;
                }
                else if(f == i) f++;
                else if(l == i) l--;
            }
            else if(v[f]+v[l] < target) f++;
            else l--;
        }
    }

    cout << cnt << '\n';

}