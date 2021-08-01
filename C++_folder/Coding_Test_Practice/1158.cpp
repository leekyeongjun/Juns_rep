#include <iostream>
#include <queue>

using namespace std;

int main()
{
    queue<int> nums;
    int command, index, temp;
    cin >> command >> index;
    for(int i = 1; i<=command; i++)
    {
        nums.push(i);
    }
    cout << "<";
    while(true)
    {
        
        for(int j =0; j<index-1; j++)
        {
            temp = nums.front();
            nums.pop();
            nums.push(temp);
        }
        cout << nums.front();
        nums.pop();
        if(nums.size() ==0)
        {
            break;
        }
        cout << ", ";

    }
    cout << ">" << endl;
}
