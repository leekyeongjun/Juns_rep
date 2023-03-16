#include <stdio.h>
int f(int n){
    if(n == 0){
        return 1;
    }
    else return n*f(n-1);
}

int main(){
    int val, result;
    printf("정수 입력: ");
    scanf("%d", &val);
    if(val < 0){
        printf("0 이상의 정수를 입력하시오.\n");
        return -1;
    }
    result =  f(val);
    printf("%d!의 계산 결과 : %d\n", val, result);
}