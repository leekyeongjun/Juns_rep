#include <cstring>
#include <iostream>
#include <chrono>
#include <thread>

using namespace std;

int ga, se;
int GRID[10000][10000];
void E(int _ga, int _se, int _val){
	GRID[_se][_ga] = _val;
	return;
}

void D(int _ga, int _se){
	GRID[_se][_ga] = 0;
	return;
}

void HE(int _ga, int _val){
	for(int i =0; i<se; i++){
		for(int j=0; j<ga; j++){
			if(i == _ga){
				GRID[i][j] = _val;
			}
		}		
	}
	return;
}

void VE(int _se, int _val){
	for(int i = 0 ; i<se; i++){
		for(int j=0; j<ga; j++){
			if(j == _se){
				GRID[i][j] = _val;
			}
		}
	}
}

void SHOW(){
	for(int i = 0; i<se; i++){
		for(int j = 0; j<ga; j++){
			cout << GRID[i][j] << " ";
		}
		cout << '\n';
	}
}

void INIT(int _ga, int _se){
	for(int i = 0 ; i<se; i++){
		for(int j = 0 ; j<ga; j++){
			GRID[i][j] = 0;
		}
	}

}
int main()
{
	memset(GRID, -1, sizeof(GRID));
	cout << "[WELCOME TO GRID TEST]" << '\n';
	
	cout << "ENTER HORIZONTAL LENGTH : ";
	cin >> ga;

	cout << "ENTER VERTICAL LENGTH : ";
	cin >> se;

	INIT(ga, se);	
	SHOW();

	while(1){
		string cmd;
		cout << "ENTER YOUR COMMAND" <<'\n';
		cout << "  ============================================ " << '\n';
		cout << "[E, ga, se, val] : enter pos value" << '\n';
		cout << "[D, ga, se, val] : delete pos value" << '\n';
		cout << "[HE, ga, val] : initiate HORIZONTAL line value" << '\n';
		cout << "[HD, ga] : delete HORIZONTAL line value" << '\n';
		cout << "[VE, se, val] : initiate VERTICAL line value" << '\n';
		cout << "[VD, se] : delete VERTICAL line value" << '\n';
		cout << "[EXIT] : quit." << '\n';

		cin >> cmd;
		if(cmd == "EXIT") break;
		else if(cmd == "E"){
			int g, s, v;
			cin >> g >> s >> v;
			E(g,s,v);
		}
		else if(cmd == "D"){
			int g,s;
			cin >> g >> s;
			D(g, s);
		}
		else if(cmd == "HE"){
			int g,v;
			cin >> g >> v;
			HE(g,v);
		}
		else if(cmd == "HD"){
			int g;
			cin >> g;
			HE(g,0);
		}
		else if(cmd == "VE"){
			int s, v;
			cin >> s >> v;
			VE(s,v);
		}
		else if(cmd == "VD"){
			int s;
			cin >> s;
			VE(s,0);
		}
		SHOW();
	}
}
