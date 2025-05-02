#include <stdio.h>

void hanoi(int n, char from, char middle, char to);
int cnt = 0;

int main(){
    int n;
    printf("원판의 개수를 입력하시오: ");
    scanf("%d", &n);

    hanoi(n, 'A', 'B', 'C');
    printf("총 이동 횟수 : %d\n", cnt);
}


void hanoi(int n, char from, char middle, char to){
    if(n == 1){
        printf("1번 원반을 %c에서 %c로 이동\n", from, to);
        cnt++;
        return;
    }
    else{
        hanoi(n-1, from, to, middle);
        printf("%d번 원반을 %c에서 %c로 이동\n", n,from,to);
        cnt++;
        hanoi(n-1, middle, from, to);
    }
}