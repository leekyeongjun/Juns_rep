#include <iostream>
#include <algorithm>
#include <vector>


using namespace std;

vector<int> A;


    // s와 e 가 같은가?
        // A[s] 가 t인가? Return 1
        // 아닌가? return 0

    // 1. Array의 중간값과 t 값 비교
        // case 1 : 중간값이 t보다 작다
            // 중간값 ~ 배열 끝에 대해 Binary Search (Recursive)
        // case 2 : 중간값이 t다
            // return 1
        // case 3 : 중간값이 t보다 크다
            // 0~ 중간값에 대해 Binary Search (Recursive)


int main(){
    int n, m, i;
    ios::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);


    cin >> n;
    for(i =0; i<n; i++){
        int a;
        cin >> a;
        A.push_back(a);
    }
    sort(A.begin(), A.end());

    cin >> m;
    for(i = 0; i<m; i++){
        int a;
        cin >> a;
        int s = 0; int e = A.size()-1;
        bool find = false;
        //cout << "Seaching on" << a << "...\n";
        while(s <= e){
            int m = (s+e)/2;
            if(A[m] == a){
                find = true;
                break;
            }
            else if(A[m] > a){
                e = m-1;
            }
            else {
                s = m+1;
            }
        }

        if(find){
            cout << 1 << '\n';
        }else{
            cout << 0 << '\n';
        }
        
    }

}