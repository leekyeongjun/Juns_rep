#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
    printf("My student ID is 2019092824\n");


    fprintf(1, "My pid is %d\n", getpid());
    if(getppid() == -1){
        fprintf(1, "No parent process\n");
    } else {
        fprintf(1, "My ppid is %d\n", getppid());
    }
    exit(0);
}