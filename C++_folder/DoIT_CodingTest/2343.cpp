#include <iostream>
#include <vector>
using namespace std;

int main(){

    int N,M;
    cin >> N >> M;

    vector<int> lec(N);

    int start;
    int end = 0;

    for(int i = 0; i<N; i++){
        cin >> lec[i];
        if(i == N-1) start = lec[i];
        end += lec[i];
    }

    while(start <= end){
        int mid = (int) (start+end)/2;

        int cnt = 1;
        int tmp = 0;

        for(int i = 0; i<N; i++){
            if(tmp+lec[i] > mid){
                cnt++;
                tmp = lec[i];
            }
            else{
                tmp+= lec[i];
            }
        }

        if(cnt > M){ // 기존 블루레이 개수론 부족함 -> 블루레이 용량이 작다는 것 -> 용량 늘려 -> start증가
            start = mid+1;
        }
        else if(cnt <= M){ // 기존 블루레이 개수보다 더 적은 수로도 가능 -> 블루레이 용량이 크다는 것 -> 용량 줄여 -> end축소
            end = mid-1;
        }
    }

    cout << start << '\n';

}