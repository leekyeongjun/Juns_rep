#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h" // relevant, because it contains the function prototype for library functions and system calls

int
main(int argc, char **argv)
{
  int i;

  if(argc < 2){
    fprintf(2, "usage: kill pid...\n"); // library function
    exit(1); // System call
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  exit(0); // system call
}
