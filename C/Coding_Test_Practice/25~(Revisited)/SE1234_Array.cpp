#include <iostream>

using namespace std;

int n;

int after(int id, int* arr){
	int a = id+1;
	if(a >= n){
		//cout << "a is overbound\n";
		return id;
	}

	while(a < n && arr[a] == -1){
		a++;
	}
	//cout << "a is " << a << '\n';
	return a;
}

int before(int id, int* arr){
	int b= id-1;
	if(b < 0){
		//cout << "b is underbound\n";
		return id;
	}
	while(b >= 0 && arr[b] == -1){
		b--;
	}
	//cout << "b is " << b << '\n';
	return b;
}

int main(int argc, char** argv)
{
    ios::sync_with_stdio(0); cin.tie(0); cout.tie(0);
	int test_case;
	int T;
	/*
	   아래의 freopen 함수는 input.txt 를 read only 형식으로 연 후,
	   앞으로 표준 입력(키보드) 대신 input.txt 파일로부터 읽어오겠다는 의미의 코드입니다.
	   //여러분이 작성한 코드를 테스트 할 때, 편의를 위해서 input.txt에 입력을 저장한 후,
	   freopen 함수를 이용하면 이후 cin 을 수행할 때 표준 입력 대신 파일로부터 입력을 받아올 수 있습니다.
	   따라서 테스트를 수행할 때에는 아래 주석을 지우고 이 함수를 사용하셔도 좋습니다.
	   freopen 함수를 사용하기 위해서는 #include <cstdio>, 혹은 #include <stdio.h> 가 필요합니다.
	   단, 채점을 위해 코드를 제출하실 때에는 반드시 freopen 함수를 지우거나 주석 처리 하셔야 합니다.
	*/
	//freopen("input.txt", "r", stdin);

	cin>>T;
	/*
	   여러 개의 테스트 케이스가 주어지므로, 각각을 처리합니다.
	*/
	for(test_case = 1; test_case <= T; ++test_case)
	{

		cin >> n;
		
		int arr[101];

		int i;
		for(i=0; i<n; i++){
			char c;
			cin >> c;
			arr[i] = c-'0';
		}

		for(i = 0; i<n; i++){
			if(arr[i] == -1){
				continue;
			}
			int a = after(i,arr);
			//cout << i << " : arr[i] = " << arr[i] << ", arr[a] = " << arr[a] << '\n';
			if(arr[i] == arr[a] && i != a){
				//cout << "arr[i] and arr[a] are same\n";
				arr[i] = arr[a] = -1;
				continue;
			}
			int b = before(i,arr);
			//cout << i << " : arr[i] = " << arr[i] << ", arr[b] = " << arr[b] << '\n';
			if(arr[i] == arr[b] && i != b){
				//cout << "arr[i] and arr[b] are same\n";
				arr[i] = arr[b] = -1;
				continue;
			}

			//cout << "both are not same\n";
		}

		cout << "#" << test_case << " ";
		for(i = 0; i<n; i++){
			if(arr[i] != -1){
				cout << arr[i];
			}
		}
		cout << '\n';
		
	}
	return 0;//정상종료시 반드시 0을 리턴해야합니다.
}