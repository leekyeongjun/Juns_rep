#include <iostream>
#include <algorithm>
using namespace std;

int N;

int deck[1001];

int main(){
	ios::sync_with_stdio(false); cin.tie(NULL); cout.tie(NULL);
	cin >> N;	
	for(int i = 0; i<N; i++){
		cin >> deck[i];
	}
	sort(deck, deck+(N-1));
	
	for(int i = 0; i<N; i++){
		int j = i+1;
		if(deck[j] != 0){
			if(i==0) deck[j] = deck[i]+deck[j];
			else deck[j] = deck[i] + deck[i]+deck[j];
		}
	}
	cout << deck[N-1] << '\n';
}
