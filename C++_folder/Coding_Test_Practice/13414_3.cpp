#include <stdio.h>
#include <iostream>
#include <set>
#include <vector>

using namespace std;

int main()

{
    int n, k, size;
    set<string> student_set;
    set<string>::iterator set_it;

    vector<string> confirmed_student;
    vector<string> input_list;


    scanf("%d%d" ,&n,&k);

    for(int i = 0 ; i< k; i ++)
    {
        string _student;
        cin >> _student;
        input_list.push_back(_student);
    }

    for(int j=0; j<k; j++)
    {
        string m_student = input_list[j];
        set_it = student_set.find(m_student);

        if(set_it == student_set.end())
        {
            student_set.insert(m_student);
            confirmed_student.push_back(m_student);
        }
    }
    size = confirmed_student.size();
    for(int l = size-1; l >size-n && l>=0; --l)
    {
        cout << confirmed_student[l] << "\n";
    }

}