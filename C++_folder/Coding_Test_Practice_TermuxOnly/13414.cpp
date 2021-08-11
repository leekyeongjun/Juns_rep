#include <iostream>
#include <map>
#include <string>

using namespace std;

int main() {
	map<string, int> students;
	int n, k;
	cin >> n >> k;
	int i = 0;
	int minnum;
	
	while(k>0){
		bool isExist = false;
		string Student_number;
		cin >> Student_number;
		auto pairData = make_pair(Student_number, i);
		
		for(auto& myPair : students)
		{
			if(pairData.first == myPair.first){
				myPair.second = pairData.second;
				isExist = true;
			}
			else{
				isExist = false;
			}
		}
		
		if(isExist == true){}
		else if(isExist == false){
			students.insert(pairData);
		}
		k--;
		i++;
	}
	
}
