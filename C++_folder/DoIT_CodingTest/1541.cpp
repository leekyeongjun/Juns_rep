#include <iostream>
#include <vector>
#include <queue>

using namespace std;


int main(){

    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    string buf;
    cin >> buf;

    vector<pair<int,int>> pos;
    vector<char> ops;
    ops.push_back('+');

    vector<int> nums;

    int start = 0;
    for(int i = 0; i<buf.size(); i++){
        if(buf[i] == '+' || buf[i] == '-'){
            ops.push_back(buf[i]);
            pos.push_back({start,(i-start)});
            start = i+1;
        }
    }
    pos.push_back({start, buf.size()});

    for(int i = 0; i<pos.size(); i++){
        nums.push_back(stoi(buf.substr(pos[i].first, pos[i].second)));
    }

    int cri = -1;

    for(int i = 0; i<ops.size(); i++){
        if(ops[i] == '-'){
            cri = i;
            break;
        }
    }

    int sum = 0;
    if(cri == -1){
        for(int i = 0; i<nums.size(); i++){
            sum += nums[i];
        }       
    }
    else{
        for(int i = 0; i<nums.size(); i++){
            if(i < cri) sum += nums[i];
            else sum -= nums[i];
        }
    }
    cout << sum << '\n';




}


