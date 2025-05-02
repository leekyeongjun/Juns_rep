#include <iostream>
#include <vector>

using namespace std;

vector<int> u;

int n, m;

int find(int a){
    //cout << "finding..." << '\n';
    if(u[a] != a){
        return u[a] = find(u[a]);    
    }
    else{
        return a;
    }
}

void unify(int a, int b){

    int o_b = find(b);
    int o_a = find(a);
    if (o_b != o_a) u[o_b] = u[o_a];
}


int main(){
    ios::sync_with_stdio(0); cin.tie(0); cout.tie(0);
    

    cin >> n >> m;
    int i;

    for(int i = 0; i<=n; i++){
        u.push_back(i);
    }
    
    for(i = 0; i<m; i++){
        int op, a, b;
        cin >> op >> a >> b;

        if(op == 0){
            unify(a,b);
        }
        else{
            if(find(a) == find(b)){
                cout << "YES" << '\n';
            }else{
                cout << "NO" << '\n';
            }
        }
    }


}