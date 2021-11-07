#include <iostream>
#include <map>
#include <vector>
#include <algorithm>


using namespace std;
bool cmp(const pair<string,int>& a, const pair<string,int>& b)
{
	if (a.second == b.second) return a.first < b.first;
	return a.second < b.second;
}
int main(){
	int input_nums, limit;
	map<string, int> students;
	map<string, int>::iterator it;
	cin >>limit >>input_nums;
	string name;
	
	for(int i = 0; i<input_nums; i++){
		cin >> name;
		it = students.find(name);
		if(it != students.end())
		{
			students.erase(it++);
		}
		students.insert(make_pair(name, i));
		
	}
	vector<pair<string,int>> vec(students.begin(), students.end());

	sort(vec.begin(), vec.end(), cmp);

	for(int i = 0; i<limit; i++){
		cout << vec[i].first <<endl;
	}
