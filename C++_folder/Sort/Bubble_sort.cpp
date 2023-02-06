#include <iostream>
#include <vector>

using namespace std;

/*
    버블정렬

    배열을 돌면서, 두 배열값을 바꿔주는 것으로 정렬하는 방법.

    5 2 3 4 1

    2 5 3 4 1

    2 3 5 4 1

    2 3 4 5 1

    2 3 4 1 5

    2 3 1 4 5

    2 1 3 4 5

    1 2 3 4 5

*/ 


int main()
{
    int N; // 수의 개수
    cin >> N;
    vector<int> v(N);

    for(int i = 0; i<N; i++) cin>> v[i]; // 입력받기

    //버블정렬 - 오름차순

    for(int i = 0; i<N; i++){
        for(int j = 0; j<i; j++){
            if(v[i] < v[j]){
                int tmp;
                tmp = v[i];
                v[i] = v[j];
                v[j] = tmp;
            }
        }
    }

    //출력 

    for(int i = 0; i<N; i++){
        cout << v[i] << ' ';
    }
    cout << '\n';

}