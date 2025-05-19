//https://swexpertacademy.com/main/code/problem/problemDetail.do?problemLevel=2&problemLevel=3&contestProbId=AV15Khn6AN0CFAYD&categoryId=AV15Khn6AN0CFAYD&categoryType=CODE&problemTitle=%EB%AC%B8%EC%A0%9C%ED%95%B4%EA%B2%B0&orderBy=FIRST_REG_DATETIME&selectCodeLang=CCPP&select-1=3&pageSize=10&pageIndex=1

#include <iostream>
#include <queue>
#include <string>
#include <vector>

using namespace std;

int n;

int main(){
    ios::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);

    cin >> n ;
    int i;
    for(i=0; i<n; i++){
        string s; int b;
        cin >> s >> b;
        vector<int> arr;
        for(char a : s){
            arr.push_back(a-'0');
        }
        
        /*

        3 2 8 8 8
        모든 경우의 수 : 5! : 120가지

        1 2 3 4 5

        2 3 1 5 4 교환횟수 : 3, 5, 7, 9, 11 ...

        5 4 3 2 1 교환횟수 : 2, 4, 6, 8, 10 ...

        1 2 3 4 5 교환횟수 : 0, 2, 4, 6, 8 ...


        */
    }
    
}