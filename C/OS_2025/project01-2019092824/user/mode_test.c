#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int 
main(int argc, char *argv[])
{
    int pid = fork();
    if (pid == 0) {
        int ppid = fork();
        if(ppid == 0){
            int p5 = 0;
            printf("5\n");
            while (1) {
                p5++;
            }
        }
        else{
            int p4 = 0;
            printf("4\n");
            while (1) {        
                p4++;   

            }
            printf("4 done\n");
            exit(0);
        }

    } else {
        int p3 = 0;
        printf("3\n");
        while (1) {
            p3++;

        }
        printf("3 done\n");
    }
    wait(0);
    exit(0);
}