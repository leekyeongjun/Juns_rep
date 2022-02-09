#include <stdio.h>


using namespace std;


int main()
{
	int arr[101];

	for(int i =0; i<101; i++){
		arr[i] = i*i;
	}

	int m,n;
	int sum,cnt,min = 0;
	scanf("%d %d", &m, &n );

	for(int i = 0; i<101; i++){
		if(arr[i] >= m && arr[i] <= n){
			sum += arr[i];
			if(cnt == 0){
				min = arr[i];
			}
			cnt ++;
		}
	}

	if(cnt == 0){
		sum = -1;
		printf("%d", sum);
	}
	else{
		printf("%d\n%d", sum, min);
	}


}
