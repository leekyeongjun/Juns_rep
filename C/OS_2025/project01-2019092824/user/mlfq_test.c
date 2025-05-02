#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int 
main(int argc, char *argv[])
{
    mlfqmode();
    int pid = fork();
    if (pid == 0) {
        int ppid = fork();
        if(ppid == 0){
            int p5 = 0;
            printf("5\n");
            while (1) {
                p5++;
                if(p5 % 1000 == 0){
                    printf("5 lev is %d\n", getlev());
                }
            }
        }
        else{
            int p4 = 0;
            printf("4\n");
            while (1) {
                
                p4++;   
                if(p4 % 1000 == 0){
                    int setpriority_result = setpriority(4, 0);
                    if(setpriority_result == 0){
                        printf("p4 set priority : to 0\n");
                    }else if(setpriority_result == -1){
                        printf("not found a process\n");
                    }else if (setpriority_result == -2){
                        printf("Invalid setpriority\n");
                    }else{
                        printf("Error in setpriority\n");
                        exit(1);
                    }
                }
            }
            printf("4 done\n");
            wait(0);
            exit(0);
        }


    } else {
        int p3 = 0;
        printf("3\n");
        while (1) {
            p3++;

            if(p3 % 1000 == 0){
                int setpriority_result = setpriority(3, 2);
                if(setpriority_result == 0){
                    printf("p3 set priority : to 2\n");
                }else if(setpriority_result == -1){
                    printf("not found a process\n");
                }else if (setpriority_result == -2){
                    printf("Invalid setpriority\n");
                }else{
                    printf("Error in setpriority\n");
                    exit(1);
                }
            }
        }
        printf("3 done\n");
    }
    wait(0);
    exit(0);
}