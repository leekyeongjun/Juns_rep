#include <iostream>
#include <cstdio>
#include <map>
#include <string>
 
using namespace std;
 
map<string, float> m;
float cnt = 0;
 
int main()
{
    while (1)
    {
        string s;
        getline(cin, s);
        if (cin.eof())
            break;
        if (m.find(s) != m.end())
        {
            m[s]++;
        }
        m.insert({s, 1});
        cnt++;
    }
 
    for (auto i = m.begin(); i != m.end(); i++)
    {
        cout << i->first;
        printf(" %.4f\n", (((i->second) / cnt) * 100));
    }
 
    return 0;
}
