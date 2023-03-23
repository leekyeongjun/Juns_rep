#include <stdio.h>
#include <stdlib.h>

typedef struct{
    int a;
    char b;
    float c; 
} package;

int main(){
    package** packages;
    int n, m;
    scanf("%d", &n);

    packages = (package**)malloc(n*sizeof(package*));
    for(int i = 0; i<n; i++){
        packages[i] = (package*)malloc(m*sizeof(package));
    }


}