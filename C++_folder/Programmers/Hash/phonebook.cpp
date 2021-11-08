#include <string>
#include <vector>

using namespace std;

bool solution(vector<string> phone_book){
	bool answer = true;
	for(int i = 0 ; i<phone_book.size()-1; i++){
		if(phone_book[i].at(phone_book[i].size()) == phone_book[i+1].at(0)){
			answer = false;
			break;
		}
	}

	return answer;
}
