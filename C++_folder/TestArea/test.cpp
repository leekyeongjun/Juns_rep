#include <iostream>
#include <queue>
#include <string>

using namespace std;

int main()
{
	while(true){
		string a;
		cin >> a;
		bool pal = true;

		if(a == "0") break;
		queue<int> f,b;	
		for(int i = 0 ; i<a.size(); i++) f.push(a[i]-'0');
		for(int i = a.size()-1; i >0; i--) b.push(a[i]-'0');
	
		while(!f.empty() && !b.empty()){
			int ft = f.front();
			int bt = b.front();
			if(ft != bt){
				pal = false;
				break;
			}
			f.pop();
			b.pop();
		}
		if(pal) cout << "yes" << '\n';
		else cout << "no" << '\n';
	}


}
