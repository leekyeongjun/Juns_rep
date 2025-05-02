#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int 
main(int argc, char *argv[])
{
    int pid = fork();
    if (pid == 0) {
        for (int i =0; i <= 500; i++) {
            printf("child!\n");
            yield();
        }
    } else {
        for (int i =0; i <= 500; i++) {
            printf("parent!\n");
            yield();
        }
    }
    exit(0);
}