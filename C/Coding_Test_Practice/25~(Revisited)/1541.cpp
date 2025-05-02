#include <iostream>
#include <vector>
#include <sstream>

using namespace std;

int main(){
    ios::sync_with_stdio(0); cin.tie(0); cout.tie(0);

    vector<char> ops;
    vector<int> nums;
    string input;
    getline(cin,input);
    stringstream ss(input);
    

    while(!ss.eof()){
        int n;
        char o;
        if(ss >> n){
            nums.push_back(n);
        }
        if(ss >> o){
            ops.push_back(o);
        }
    }

    int result = nums[0];
    bool mode = false;
    for(int i = 1; i<nums.size(); i++){
        if(ops[i-1] == '-'){
            mode = true;
            result -= nums[i];
        }
        if(ops[i-1] == '+'){
            if(mode){
                result -= nums[i];
            }else{
                result += nums[i];
            }
        }
    }
    cout << result << '\n';
}