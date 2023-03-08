#include <iostream>
#include <stack>

using namespace std;

int main(){
    ios::sync_with_stdio(0); cin.tie(NULL); cout.tie(NULL);

    string a;
    cin >> a; 

    stack<char> front;
    stack<char> end;

    int del;
    int size = a.size();
    del = (int) size/2;


    for(int i = 0; i<del; i++){
        front.push(a.at(i));
    }
    // noooon

    if(size%2 == 0){
        for(int i = a.size()-1; i>=del; --i){
            end.push(a.at(i));
        }
    }
    else{
        for(int i = a.size()-1; i>del; --i){
            end.push(a.at(i));
        }
    }
    bool ans = true;

    while(!front.empty() && !end.empty()){
        if(front.top() != end.top()) ans = false;
        front.pop(); 
        end.pop();
        if(!ans) break;
    }

    if(ans) cout << 1 << '\n';
    else cout << 0 << '\n';
}