#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

int main()
{
    int n,k,size;
    cin >> n;
    vector<int> arr;
    for(int i =0; i< n; i++){
        cin >> k;
        arr.push_back(k);
        size = arr.size();
        sort(arr.begin(),arr.end());
        
        if(size%2 == 0)
        {
            cout << arr[size/2-1] << endl;
        }
        else
        {
            cout << arr[size/2] << endl;
        }
    }
}