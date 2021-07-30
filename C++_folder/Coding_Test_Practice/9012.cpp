// Using <string>
#include <iostream>
#include <string>

using namespace std;

void isVPS(string s)
{
    int opened = 0;

    bool isopened = false;

    for (int i = 0; i < s.size(); i++)
    {
        if (s[i] == '(')
        {
            isopened = true;
            opened++;
        }
        else if (s[i] == ')' && isopened)
        {
            opened--;
            if (opened == 0)
            {
                isopened = false;
            }
        }
        else
        {
            isopened = true;
            break;
        }
    }

    if (isopened == false)
    {
        cout << "YES" << endl;
    }
    else
    {
        cout << "NO" << endl;
    }
}

int main()
{
    string s;
    int command;
    cin >> command;
    for (int i = 0; i < command; i++)
    {
        cin >> s;
        isVPS(s);
    }
}