#include <iostream>
#include <string>
using namespace std;

int Count(string s)
{
    int count = s.size();
    for (int i = 0; i < s.size(); i++)
    {
        if (i > 0)
        {
            if (s.at(i) == '=')
            {
                if (s.at(i - 1) == 'c' || s.at(i - 1) == 's')
                {
                    --count;
                }
                else if (s.at(i - 1) == 'z')
                {
                    if (i > 1)
                    {
                        if (s.at(i - 2) == 'd')
                        {
                            --count;
                        }
                        --count;
                    }
                    else
                    {
                        --count;
                    }
                }
            }
            else if (s.at(i) == '-')
            {
                if (s.at(i - 1) == 'c' || s.at(i - 1) == 'd')
                {
                    --count;
                }
            }
            else if (s.at(i) == 'j')
            {
                if (s.at(i - 1) == 'n' || s.at(i - 1) == 'l')
                {
                    --count;
                }
            }
        }
    }
    return count;
}

int main()
{
    string s;
    cin >> s;
    cout << Count(s) << endl;
}