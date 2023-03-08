#include <iostream>
#include <vector>
using namespace std;


int main(){
    
    
    

    double sum = 0;
    double wholesum = 0;
    for(int i = 0; i <20; i++){
        string name;
        double points;
        
        string grade;
        double grades;
        cin >> name >> points >> grade;

        bool addable = true;
        if(grade == "A+"){
            grades = 4.5;
        }
        else if(grade == "A0"){
            grades = 4.0;
        }
        else if(grade == "B+"){
            grades = 3.5;
        }
        else if(grade == "B0"){
            grades = 3.0;
        }
        else if(grade == "C+"){
            grades = 2.5;
        }
        else if(grade == "C0"){
            grades = 2.0;
        }
        else if(grade == "D+"){
            grades = 1.5;
        }
        else if(grade == "D0"){
            grades = 1.0;
        }
        else if(grade == "P"){
            grades = -1;
            addable = false;
        }
        else if(grade == "F"){
            grades = 0.0;
        }

        if(addable){
            sum+= points;
            wholesum += (points*grades);
        }
    }
    cout << fixed;
    cout.precision(6);
    cout << wholesum/sum << '\n' ;
}