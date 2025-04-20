#include <iostream>
#include <map>
using namespace std;

int main(){
    
    ios_base ::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);
    
    int input_nums, limit;
    map<string, int> students;
    cin >>limit >>input_nums;
    string name;

    for(int i = 0; i<input_nums; i++){

        cin >> name;
        map<string,int>::iterator it;
        it = students.find(name);
        if(it != students.end())
        {
            students.erase(name);
        }
        
        students.insert(make_pair(name,i));
    }

    int size = students.size();
    for(auto& mypair : students){
        if(limit != 0 && size != 0){
            cout << mypair.first << "\n";
            limit --;
            size --;
        }
        else{
            break;
        }

    }
}
