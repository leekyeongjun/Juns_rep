#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"


void
sys_yield(void){
    setyieldpid(myproc()->pid);
    yield();
    return;
}


int
sys_fcfsmode(void){
    if(fcfsmode() == -1){
        //printf("The mode is already fcfs\n");
        return -1;
    }
    printf("The mode is now FCFS\n");
    yield();
    return 0;
}

int
sys_mlfqmode(void){
    if(mlfqmode() == -1){
        //printf("The mode is already mlfq\n");
        return -1;
    }
    printf("The mode is now MLFQ\n");
    yield();
    return 0;
}

int
sys_getlev(void){
    struct proc *p = myproc();
    int lev = getlev(p);
    return lev;
}

int
sys_setpriority(void){
    int pid, np;
    argint(0, &pid);
    argint(1, &np);
    
    return setpriority(pid, np);
}



