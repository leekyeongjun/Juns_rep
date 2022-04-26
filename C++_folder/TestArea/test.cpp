#include <iostream>
#include <map>
using namespace std;


int main(){
	int T;
	cin >> T;

	for(int i = 0 ; i< T; i++){
		map<string, int> m;
		int clothes[31] = {0,};
		int cnum;
		int ans = 1;
		cin >> cnum;
		for(int j =0 ; j<cnum; j++){
			string c, tp;
			cin >> c >> tp;
			map<string, int>::iterator it;
			it = m.find(tp);
			if(it == m.end()){
				m.insert({tp, j});
				clothes[j]++;
			}
			else{
				clothes[it->second]++;
			}
		}

		
		for(int k=0; k<cnum; k++){
			if(clothes[k] != 0)
				//cout << "TYPE : " << k << ", " << clothes[k] << "ea." << '\n';
				ans *= (clothes[k]+1);
		}

		cout << ans-1 << '\n';
	

		
	}

}
