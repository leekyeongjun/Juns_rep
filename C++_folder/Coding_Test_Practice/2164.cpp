#include <iostream>
#include <deque>

using namespace std;

int main()
{
    deque<int> dq;
    int command;
    cin >> command;

    //inserting numbers in deque
    for (int i = 0; i < command; i++)
    {
        dq.push_back(i + 1);
    }

    //discarding & adding cards
    while (dq.size() > 1)
    {

        dq.pop_front();
        if (dq.size() == 1)
        {
            break;
        } // need?

        dq.push_back(dq.front());
        dq.pop_front();
        if (dq.size() == 1)
        {
            break;
        } // need?
    }

    cout << dq.front() << endl;
}