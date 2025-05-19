#include <iostream>

using namespace std;



int main(){
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    int T;
    cin >> T;
    for(int t=0; t<T; t++){
        int id;
        cin >> id;
        int cnt[102] = {0,};
        int i = 0; 
        for(i; i<1000; i++){
            int a;
            cin >> a;
            cnt[a] ++;
        }

        int tmp = 101;
        cnt[101] = -1;

        for(i = 0; i<=100; i++){
            if(cnt[tmp] <= cnt[i]){
                tmp = i;
            }
        }

        cout << "#" << id<< ' '<< tmp << '\n';
    }

}