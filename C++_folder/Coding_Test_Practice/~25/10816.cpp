#include <iostream>
#include <vector>
#include <map>
 
using namespace std;
int main()
{
    ios::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);
    //안넣었을때 time초과
 
    int n,k;
    cin >> n;
    map<int, int> cards;
    map<int, int>::iterator it;
    //unordered map썼으면 더 빨랐을것 같음
    for(int i = 0; i<n; i++){
        int num;
        cin >> num;
        it = cards.find(num);
        if(it==cards.end())
        {
            cards.insert(make_pair(num,1));
        }
        else
        {
            it->second += 1;
        }
    }
    cin >> k;
    vector<int> cmp_cards;
    for(int i = 0; i<k; i++)
    {
        int num;
        cin >> num;
 
        cmp_cards.push_back(num);
    }
 
    vector<int> answer;
    for(int i=0; i<k; i++)
    {
        it = cards.find(cmp_cards[i]);
        if(it==cards.end())
        {
            answer.push_back(0);
        }
        else
        {
            answer.push_back(it->second);
        }
    }
 
    for(int i=0; i<answer.size(); i++)
    {
        cout << answer[i];
 
        if(i<answer.size()-1){cout << " ";}
        else{cout << "\n";}
    }
    cout << endl;
}
