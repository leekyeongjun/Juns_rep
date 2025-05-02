#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

extern struct spinlock wait_lock;
int
getppid(void)
{
    struct proc *p = myproc(); // Get the current process
    int ppid;
    
    acquire(&wait_lock);       // Acquire the wait_lock to safely access p->parent
    if (p->parent) {
        ppid = p->parent->pid;   // Retrieve the parent process's PID
    } else {
        ppid = -1;               // No parent (shouldn't happen for normal processes)
    }
    release(&wait_lock);       // Release the lock after accessing p->parent
    
    return ppid;               // Return the parent process's PID
}

int
sys_getppid(void)
{
    return getppid();
}