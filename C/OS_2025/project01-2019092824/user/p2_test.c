#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int 
main(int argc, char *argv[])
{
    int pid = fork();
    if (pid == 0) {
        int ppid = fork();
        if (ppid == 0) {
            for (;;) {printf("6\n");}
        } else {
            for (;;) {printf("5\n"); yield();}
        }
    } else {
        for (;;) {printf("4\n"); yield();}
    }
    exit(0);
}