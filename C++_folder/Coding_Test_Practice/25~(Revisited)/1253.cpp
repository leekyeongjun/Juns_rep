#include <iostream>
#include <queue>
#include <vector>
#include <algorithm>
#define sum arr[start]+arr[end]
int main(){

    using namespace std;

    ios::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);

    int n;
    cin >> n;
    
    int i;
    vector<int> arr;
    for(i=0; i<n; i++){
        int a;
        cin >> a;
        arr.push_back(a);
    }

    sort(arr.begin(), arr.end());

    /*
    10 9 7 3 2 1
    
    sum = 10
    break;
     T   s
    10 | 9 7 3 2 1
                 e

    sum = 8
    end --;

       T   s
    10 9 | 7 3 2 1
                 e
    

    sum = 9
    break;

       T   s
    10 9 | 7 3 2 1
               e


    sum = 4
    end --

         T   s  
    10 9 7 | 3 2 1
                 e
               
    sum = 5
    end --

         T   s  
    10 9 7 | 3 2 1
               e

    s == e, break;

         T   s  
    10 9 7 | 3 2 1
             e
   
    sum = 3
    break;

           T   s
    10 9 7 3 | 2 1
                 e
    */

    int cnt = 0;

    for(i =0; i<n; i++){
        int target = arr[i];
        int start = 0;
        int end = n-1;
        
        while(start < end){
            if(sum == target){
                if(start != i && end != i){
                    cnt++;
                    break;
                }else{
                    if(start == i){
                        start ++;
                    }else{
                        end --;
                    }
                }

            }else if(sum < target){
                start ++;

            }else{
                end --;
            }
        }

    }

    cout << cnt << '\n';
    return 0;
}