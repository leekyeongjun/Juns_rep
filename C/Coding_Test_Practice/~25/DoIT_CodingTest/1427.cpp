#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(NULL);
    cout.tie(NULL);

    string s;
    cin >> s;

    vector<int> v;

    for(int i = 0; i<s.size(); i++) v.push_back(s[i] - '0');

    sort(v.begin(), v.end());

    for(int i = v.size()-1; i>=0; i--) cout << v[i]; cout << '\n';
    

}