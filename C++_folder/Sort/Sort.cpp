#include <iostream>
#include <bits/stdc++.h>

using namespace std;

int n = 10;
int target[10] = {7,5,9,0,3,1,6,2,4,8};

void quickSort(int* target, int start, int end){
	if(start >= end) {return;}
	// 재귀 종료 조건 : 인덱스 값이 같아진다
	int pivot = start;
	int left = start + 1;
	int right = end;
	// 7 5 9 0 3 1 6 2 4 8
	// p l               r

	while(left <= right){
		while(left <= end && target[left] <= target[pivot]) left++;
		//오른쪽으로 계속 이동, 피벗보다 큰 값 등장시 맨 아랫줄로
		while(right >start && target[right] >= target[pivot]) right --;
		// 왼쪽으로 계속 이동, 피벗보다 작은 값 등장시 맨 아랫줄로
		if(left > right) swap(target[pivot], target[right]);
		//엇갈리면 피벗과 작은 걸 바꿈
		else swap(target[left], target[right]);
		//잘 가고 있으면 위치 바꿈
	}
	quickSort(target, start, right-1);
		//재귀 (피벗기준 왼쪽)
	quickSort(target, right+1, end);
		//재귀 (피벗기준 오른쪽)
}

int main()
{
/*
//Selection Sort
	for(int i = 0; i<n; i++){
		int min_index = i;
		//가장 작은 원소를 첫번째 거라고 생각하기
		for(int j = i+1; j<n; j++){
			if(target[min_index] > target[j]){
				min_index = j;
				//배열을 돌면서 가장 작은 원소 찾기
			}
		}
		swap(target[i], target[min_index]);
		//배열에서 위치 바꾸기
	}

	cout << "Selection Sort _ O(N^2)" << '\n';
//

//Insertion Sort
	for(int i = 1; i<n; i++){
		//i가 1부터 시작하는 이유는 첫번째 원소는 정렬되어있다고 가정하기 때문
		for(int j = i; j>0; j--){
			if(target[j] < target[j-1]){
				swap(target[j], target[j-1]);
			}
			else break;
		}
	}
	cout << "Insertion Sort _ O(N^2) / best is O(N)" << '\n';
//

//Quick Sort
	quickSort(target, 0, n-1);
	cout << "Quick Sort _ O(NlogN)" << '\n';
//

*/
	for(int i = 0; i<n; i++){
		cout << target[i] << " ";
	}

}

