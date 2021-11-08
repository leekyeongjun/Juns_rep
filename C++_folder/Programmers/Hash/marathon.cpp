#include <string>
#include <vector>
#include <unordered_map>

using namespace std;

string solution(vector<string> participant, vector<string> completion){
	string answer = "";
	unordered_map<string, int> m;

	for(int i = 0; i<participant.size(); i++){
		m[participant[i]]++;
		
	}

	unordered_map<string, int>::iterator it;
	for(int i = 0; i<completion.size(); i++){
		it = m.find(completion[i]);
		if(it != m.end()){
			it->second -= 1;
			if(it->second == 0){
				m.erase(it);
			}
		}
	}

	it = m.begin();
	answer = it -> second;

	return answer;
}
