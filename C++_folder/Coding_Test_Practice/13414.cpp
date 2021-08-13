#include <iostream>
#include <map>
using namespace std;

int main(){
	int input_nums, limit;;
	map<int, string> students;
	cin >>limit >>input_nums;
	string name;
	
	for(int i = 0; i<input_nums; i++){
		cin >> name;
		for(int j = 0; j<students.size(); j++){
			if(name.compare(students[j])==0){
				students.erase(j);
			}
		}
		students.insert(make_pair(i,name));
	}
	
	for(auto& mypair : students){
		if(limit == 0){
			break;
		}
		if(mypair.second.compare("")!=0){
			cout << mypair.second << endl;
			limit --;
		}
	}
}
