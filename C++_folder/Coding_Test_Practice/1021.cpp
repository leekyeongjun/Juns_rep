#include <iostream>
#include <deque>
using namespace std;

deque<int> L_spin(deque<int> dq)
{
    dq.push_back(dq.front());
    dq.pop_front();
    return dq;
}

deque<int> R_spin(deque<int> dq)
{
    dq.push_front(dq.back());
    dq.pop_back();
    return dq;
}

deque<int> extract(deque<int> dq)
{
    dq.pop_front();
    return dq;
}
int main()
{
    //settings
    int dq_size, index_size, counter = 0;
    deque<int> dq;
    deque<int> indexes;

    cin >> dq_size;
    for (int i = 0; i < dq_size; i++)
    {
        dq.push_back(i + 1);
    }

    cin >> index_size;
    for (int i = 0; i < index_size; i++)
    {
        int n;
        cin >> n;
        indexes.push_back(n);
    }

    for (int i = 0; i < index_size; i++)
    {
        int L_num = 0;
        int r_num = 0;

        deque<int> Ldq = dq;
        deque<int> Rdq = dq;

        while (Ldq.front() != indexes.at(i))
        {
            Ldq = L_spin(Ldq);
            ++L_num;
        }
        while (Rdq.front() != indexes.at(i))
        {
            Rdq = R_spin(Rdq);
            ++r_num;
        }
        counter += (L_num > r_num) ? r_num : L_num;

        dq = extract(Ldq);
    }
    cout << counter << endl;
}
