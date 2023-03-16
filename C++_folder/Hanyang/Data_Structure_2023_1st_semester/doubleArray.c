#include <stdio.h>
#include <stdlib.h>

int main(){
    int ** matrix;
    int row, col, i, j;
    printf("input the row : ");
    scanf("%d", &row);
    printf("input the col : ");
    scanf("%d", &col);

    matrix = (int**)malloc(row * sizeof(int*));
    for(i = 0; i<row; i++){
        matrix[i] = (int*)malloc(col* sizeof(int));
    }

    for(i = 0; i<row; i++){
        for(j = 0; j<col; j++){
            matrix[i][j] = i*col + j;
        }
    }

    for(i = 0; i<row; i++){
        for(j = 0; j<col; j++){
            printf("%d\t", matrix[i][j]);
        }
        printf("\n");
    }

    for(i = 0; i<row; i++){
        free(matrix[i]);
    }
    free(matrix);
}