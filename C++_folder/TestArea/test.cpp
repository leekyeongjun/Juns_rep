#include <iostream>
#include <map>
#include <cstdlib>
#include <stdexcept>
#include <string>

using namespace std;

map<int, string> m;

int main()
{
	int N, K;
	cin >> N >> K;

	for(int i = 0 ; i < N; i++){
		string s;
		cin >> s;
		m.insert({i+1, s});
	}
	
	for(int i = 0 ; i<K; i++){
		string b;
		map<int,string>::iterator it;
		cin >> b;
		try{
			int n = stoi(b);
			it = m.find(n);
			if(it != m.end()){
				cout << it->second << '\n';
			}
		} catch(const std::invalid_argument&){
			for(it = m.begin(); it != m.end(); it++){
				if(it->second.compare(b)==0){
					cout << it->first << '\n';
				}
			}
		}
	}
}
