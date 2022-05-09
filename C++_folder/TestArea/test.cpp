#include <iostream>
using namespace std;

int arr[9] = {1,2,3,4,5,6,7,8};
int arr_2[9] = {8,7,6,5,4,3,2,1};
int cmp[9];
int main()
{
	for(int i = 0 ; i < 8; i++){
		cin >> cmp[i];
	}
	if(cmp[0] == 1 || cmp[0] == 8){
		if(cmp[0] == 1){
			for(int i = 1; i<8; i++){
				if(arr[i] != cmp[i]) {
					cout << "mixed" << '\n'; 
					return 0;
				}
			}
			cout << "ascending" << '\n';
			return 0;
		}
		else if(cmp[0] == 8){
			for(int i=1; i<8; i++){
				if(arr_2[i] != cmp[i]){
					cout << "mixed" << '\n';
					return 0;
				}
			}
			cout << "descending" << '\n';
			return 0;
		}
	}
	else{
		cout << "mixed" << '\n';
	}
}
