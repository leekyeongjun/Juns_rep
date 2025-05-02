#include <iostream>
#include <vector>
#include <algorithm>
 
using namespace std;
 
class Operator{
    public:
    int plus;
    int minus;
    int multiply;
    int divide;
    
    Operator(int p, int m, int mu, int d){
    plus = p; minus=m; multiply=mu; divide=d;}
    int ReturnTotal(){return (plus+minus+multiply+divide);}
};
 
int main(){
    ios::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);
 
    int num;
    cin >> num;
 
    vector<int> nums;
    for(int i = 0; i<num; i++){
        int n;
        cin >> n;
        nums.push_back(n);
    }
 
    int plus, minus, multiply, divide;
    cin >> plus >> minus >> multiply >> divide;
    Operator op(plus,minus,multiply,divide);
    
    plus = op.plus;
    minus = op.minus;
    multiply = op.multiply;
    divide = op.divide;
 
    vector<int> arr;
    // first input : arr
    vector<vector<int>*> permutation;
    // vector pointer's vector : permutation
 
    while(plus != 0){arr.push_back(1); plus --;}
    while(minus != 0){arr.push_back(2); minus --;}
    while(multiply != 0){arr.push_back(3); multiply --;}
    while(divide !=0){arr.push_back(4); divide --;}
 
    // adding vector pointer 'newvec' into 'permutation'
    do{
        vector<int>* newvec = new vector<int>;
        for(auto it = arr.begin(); it != arr.end(); ++it)
        {
            newvec->push_back(*it);
        }
        permutation.push_back(newvec);
    } while(next_permutation(arr.begin(),arr.end()));
    
    
    
    //brute force!
    vector<int> ans;
    //To compare results of every calculation
 
    for(int i = 0; i<permutation.size(); i++){
        int index = 0;
        int res;
        while(index<permutation[i]->size()){
            if(index == 0)
            {
                if(permutation[i]->at(index) == 1)
                    {res = nums[index]+nums[index+1];}
                else if(permutation[i]->at(index) == 2)
                    {res = nums[index]-nums[index+1];}
                else if(permutation[i]->at(index) == 3)
                    {res = nums[index]*nums[index+1];}
                else if(permutation[i]->at(index) == 4)
                    {res = nums[index]/nums[index+1];}
                index ++;
            }
            else
            {
                if(index + 1 >nums.size()){break;}
                if(permutation[i]->at(index) == 1)
                    {res=res+nums[index+1];}
                else if(permutation[i]->at(index) == 2)
                    {res=res-nums[index+1];}
                else if(permutation[i]->at(index) == 3)
                    {res=res*nums[index+1];}
                else if(permutation[i]->at(index) == 4)
                    {res=res/nums[index+1];}
                index ++;
            }
        }
        ans.push_back(res);
    }
    sort(ans.begin(),ans.end());
    if(ans.size() == 1){cout << ans[0] << '\n' << ans[0] << '\n';}
    else
    {
        cout << ans[ans.size()-1] << '\n';
        cout << ans[0] << '\n';
    }
}
