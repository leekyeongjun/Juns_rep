#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int 
main(int argc, char *argv[])
{
    fcfsmode();
    int pid = fork();
    if (pid == 0) {
        int ppid = fork();
        if(ppid == 0){
            int p6 = 0;
            while (p6 < 100000) {
                //printf("6\n");
                p6++;
            }
            printf("6 done\n");
            exit(0);
        }
        else{
            int p5 = 0;
            while (p5 < 100000) {
                //printf("5\n");
                p5++;   
            }
            printf("5 done\n");
            wait(0);
            exit(0);
        }
    } else {
        int p4 = 0;
        while (p4 < 100000) {
            //printf("4\n");
            p4++;
        }
        printf("4 done\n");
    }
    wait(0);
    exit(0);
}