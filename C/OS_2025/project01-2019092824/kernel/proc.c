#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

struct cpu cpus[NCPU];

struct proc proc[NPROC];

struct proc *initproc;

int nextpid = 1;
struct spinlock pid_lock;

extern void forkret(void);
static void freeproc(struct proc *p);

extern char trampoline[]; // trampoline.S

// helps ensure that wakeups of wait()ing
// parents are not lost. helps obey the
// memory model when using p->parent.
// must be acquired before any p->lock.
struct spinlock wait_lock;

// scheduler mode
// 0: FCFS
// 1: MLFQ
int scheduler_mode = 0;
struct spinlock schedmode_lock;


// If yield is called by syscall, this is the pid of the process
int yieldpid = 0;
struct spinlock yieldpid_lock;

// which process was last scheduled
// only used in MLFQ
int lastpid = 0;
struct spinlock lastpid_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
  }
}

// initialize the proc table.
void
procinit(void)
{
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
  initlock(&wait_lock, "wait_lock");
  initlock(&schedmode_lock, "schedmode_lock");
  initlock(&yieldpid_lock, "yieldpid_lock");
  initlock(&lastpid_lock, "lastpid_lock");

  for(p = proc; p < &proc[NPROC]; p++) {
      initlock(&p->lock, "proc");
      p->state = UNUSED;
      p->qnum = FCFSMODE;
      p->tq = FCFSMODE;
      p->priority = FCFSMODE;
      p->kstack = KSTACK((int) (p - proc));
  }
}

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
  int id = r_tp();
  return id;
}

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
  int id = cpuid();
  struct cpu *c = &cpus[id];
  return c;
}

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
  push_off();
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
  pop_off();
  return p;
}

int
allocpid()
{
  int pid;
  
  acquire(&pid_lock);
  pid = nextpid;
  nextpid = nextpid + 1;
  release(&pid_lock);

  return pid;
}

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, or a memory allocation fails, return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->state == UNUSED) {
      goto found;
    } else {
      release(&p->lock);
    }
  }
  return 0;

found:
  p->pid = allocpid();
  p->state = USED;

  // Allocate a trapframe page.
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // An empty user page table.
  p->pagetable = proc_pagetable(p);
  if(p->pagetable == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkret;
  p->context.sp = p->kstack + PGSIZE;

  return p;
}

// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
  if(p->trapframe)
    kfree((void*)p->trapframe);
  p->trapframe = 0;
  if(p->pagetable)
    proc_freepagetable(p->pagetable, p->sz);
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
}

// Create a user page table for a given process, with no user memory,
// but with trampoline and trapframe pages.
pagetable_t
proc_pagetable(struct proc *p)
{
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();
  if(pagetable == 0)
    return 0;

  // map the trampoline code (for system call return)
  // at the highest user virtual address.
  // only the supervisor uses it, on the way
  // to/from user space, so not PTE_U.
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
              (uint64)trampoline, PTE_R | PTE_X) < 0){
    uvmfree(pagetable, 0);
    return 0;
  }

  // map the trapframe page just below the trampoline page, for
  // trampoline.S.
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
              (uint64)(p->trapframe), PTE_R | PTE_W) < 0){
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
  }

  return pagetable;
}

// Free a process's page table, and free the
// physical memory it refers to.
void
proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
  uvmfree(pagetable, sz);
}

// a user program that calls exec("/init")
// assembled from ../user/initcode.S
// od -t xC ../user/initcode
uchar initcode[] = {
  0x17, 0x05, 0x00, 0x00, 0x13, 0x05, 0x45, 0x02,
  0x97, 0x05, 0x00, 0x00, 0x93, 0x85, 0x35, 0x02,
  0x93, 0x08, 0x70, 0x00, 0x73, 0x00, 0x00, 0x00,
  0x93, 0x08, 0x20, 0x00, 0x73, 0x00, 0x00, 0x00,
  0xef, 0xf0, 0x9f, 0xff, 0x2f, 0x69, 0x6e, 0x69,
  0x74, 0x00, 0x00, 0x24, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00
};

// Set up first user process.
void
userinit(void)
{
  struct proc *p;

  p = allocproc();
  initproc = p;
  
  // allocate one user page and copy initcode's instructions
  // and data into it.
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
  p->sz = PGSIZE;

  // prepare for the very first "return" from kernel to user.
  p->trapframe->epc = 0;      // user program counter
  p->trapframe->sp = PGSIZE;  // user stack pointer

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;

  release(&p->lock);
}

// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint64 sz;
  struct proc *p = myproc();

  sz = p->sz;
  if(n > 0){
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
      return -1;
    }
  } else if(n < 0){
    sz = uvmdealloc(p->pagetable, sz, sz + n);
  }
  p->sz = sz;
  return 0;
}

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    if(p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));

  pid = np->pid;

  release(&np->lock);

  acquire(&wait_lock);
  np->parent = p;
  release(&wait_lock);

  int mode = schedmode();
  acquire(&np->lock);
  if(mode == 0){
    // FCFS
    np->qnum = FCFSMODE;
    np->tq = FCFSMODE;
    np->priority = FCFSMODE;
  }
  else{
    // MLFQ
    np->qnum = 0;
    np->tq = 0;
    np->priority = 3;
  }
  np->state = RUNNABLE;
  release(&np->lock);

  return pid;
}

// Pass p's abandoned children to init.
// Caller must hold wait_lock.
void
reparent(struct proc *p)
{
  struct proc *pp;

  for(pp = proc; pp < &proc[NPROC]; pp++){
    if(pp->parent == p){
      pp->parent = initproc;
      wakeup(initproc);
    }
  }
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
void
exit(int status)
{
  struct proc *p = myproc();

  if(p == initproc)
    panic("init exiting");

  // Close all open files.
  for(int fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd]){
      struct file *f = p->ofile[fd];
      fileclose(f);
      p->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(p->cwd);
  end_op();
  p->cwd = 0;

  acquire(&wait_lock);

  // Give any children to init.
  reparent(p);

  // Parent might be sleeping in wait().
  wakeup(p->parent);
  
  acquire(&p->lock);

  p->xstate = status;
  p->state = ZOMBIE;

  release(&wait_lock);

  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(uint64 addr)
{
  struct proc *pp;
  int havekids, pid;
  struct proc *p = myproc();

  acquire(&wait_lock);

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(pp = proc; pp < &proc[NPROC]; pp++){
      if(pp->parent == p){
        // make sure the child isn't still in exit() or swtch().
        acquire(&pp->lock);

        havekids = 1;
        if(pp->state == ZOMBIE){
          // Found one.
          pid = pp->pid;
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
                                  sizeof(pp->xstate)) < 0) {
            release(&pp->lock);
            release(&wait_lock);
            return -1;
          }
          freeproc(pp);
          release(&pp->lock);
          release(&wait_lock);
          return pid;
        }
        release(&pp->lock);
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || killed(p)){
      release(&wait_lock);
      return -1;
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
  }
}

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();

  // FCFS only
  struct proc *fcfs_select = 0;
  int fcfs_selected = 0;

  // MLFQ only
  struct proc *mlfq_select = 0;
  int mlfq_selected = 0;


  c->proc = 0;
  for(;;){

    intr_on();
    int found = 0;

    if(schedmode() == 0){
      // FCFS
      for(p = proc; p < &proc[NPROC];) {
        acquire(&p->lock);
        if(p->state == RUNNABLE) {
          if(yieldp() == 0){ // if nothing voluntarily yielded
            fcfs_select = p;
            fcfs_select -> state = RUNNING;
            c -> proc = fcfs_select;
            fcfs_selected = 1;
            swtch(&c->context, &fcfs_select->context);
          }
          else{ // if something voluntarily yielded, you have to respect that intention
            if(p->pid != yieldp()){
              fcfs_select = p;
              fcfs_select -> state = RUNNING;
              c -> proc = fcfs_select;
              fcfs_selected = 1;
              setyieldpid(0); // We handled this, so reset it
              swtch(&c->context, &fcfs_select->context);
            }
          }
        }

        c->proc = 0;
        found = 1;
        release(&p->lock);     
        
        if(fcfs_selected == 1){
          // if we select a process, p should be reset.
          p = proc;
          fcfs_selected = 0;
        }else {
          // if we are not able to find a process, we should move to the next one.
          p++;
        }

        if(schedmode() != 0){
          // if the mode is changed, we should break the loop.
          break;
        }
      }
    }
    else{
        // MLFQ
        // if global tick is 50, reset all processes. 
        if(ticks == 50){
          for(p = proc; p < &proc[NPROC];) {
            acquire(&p->lock);
            if(p->state == RUNNABLE){
              p->qnum = 0;
              p->tq = 0;
              p->priority = 3;
            }
            release(&p->lock);
            p++;
          }
          resetticks();
        }

        // Step 1. If yielded process is RUNNABLE and time quantum is not expired, select it.
        for(p = proc; p < &proc[NPROC];) {
          acquire(&p->lock);
          if(p->pid == lastp() && p->state == RUNNABLE && p->tq < TIMEQUANTUM(p->qnum)){
            mlfq_select = p;
            mlfq_selected = 1;
            break;
          }

          release(&p->lock);
          p++;
        }

        // Step 2. In scheduler, reorder processes.
        if(mlfq_selected == 0){
          for(p = proc; p < &proc[NPROC];) {
            acquire(&p->lock);
            if(p->pid == lastp() && p->state == RUNNABLE && p->tq >= TIMEQUANTUM(p->qnum)){
              // if time quantum is expired, we should demote the process.
              demoteproc(p);
            }

            release(&p->lock);
            p++;
          }
        }

        // Step 3. Find a process in L0 queue.
        if(mlfq_selected == 0){
          for(p = proc; p < &proc[NPROC];) {
            acquire(&p->lock);
            if(p->state == RUNNABLE && p->qnum == 0) {
              mlfq_select = p;
              mlfq_selected = 1;
              break;
            }
  
            release(&p->lock);
            p++;
          }
        }

        // Step 4. If there are no process to run in L0 queue, Find a process in L1 queue.
        if(mlfq_selected == 0){
          for(p = proc; p < &proc[NPROC];) {
            acquire(&p->lock);
            if(p->state == RUNNABLE && p->qnum == 1) {
              mlfq_select = p;
              mlfq_selected = 1;
              break;
            }
  
            release(&p->lock);
            p++;
          }
        }

        // Step 5. If there are no process to run in L1 queue, Find a process in L2 queue.
        // L2 queue has a scheduling policy of priority_scheduling.
        // Since we only have 4 priority levels and the maximum number of process is 64,
        // we can just brute force it.

        // L2 priority 3
        if(mlfq_selected == 0){
          for(p = proc; p < &proc[NPROC];) {
            acquire(&p->lock);
            if(p->state == RUNNABLE && p->qnum == 2 && p->priority == 3 ) {
              mlfq_select = p;
              mlfq_selected = 1;
              break;
            }
  
            release(&p->lock);
            p++;
          }
        }

        // L2 priority 2
        if(mlfq_selected == 0){
          for(p = proc; p < &proc[NPROC];) {
            acquire(&p->lock);
            if(p->state == RUNNABLE && p->qnum == 2 && p->priority == 2 ) {
              mlfq_select = p;
              mlfq_selected = 1;
              break;
            }
  
            release(&p->lock);
            p++;
          }
        }
        // L2 priority 1
        if(mlfq_selected == 0){
          for(p = proc; p < &proc[NPROC];) {
            acquire(&p->lock);
            if(p->state == RUNNABLE && p->qnum == 2 && p->priority == 1) {
              mlfq_select = p;
              mlfq_selected = 1;
              break;
            }
  
            release(&p->lock);
            p++;
          }
        }

        // L2 priority 0
        if(mlfq_selected == 0){
          for(p = proc; p < &proc[NPROC];) {
            acquire(&p->lock);
            if(p->state == RUNNABLE && p->qnum == 2 && p->priority == 0) {
              mlfq_select = p;
              mlfq_selected = 1;
              break;
            }
  
            release(&p->lock);
            p++;
          }
        }     
        
        
        // Step 6. if selected, swtch it.
        if(mlfq_selected == 1){
          mlfq_select -> state = RUNNING;
          c -> proc = mlfq_select;
          mlfq_selected = 0;

          swtch(&c->context, &mlfq_select->context);
          c->proc = 0;
          found = 1;
          release(&mlfq_select->lock);
        }

        if(schedmode() != 1){
          // if the mode is changed, we dont need to break the loop.
          // because mlfq scheduling is done outside of the loop.
        }     
    }
    if(found == 0) {
      // nothing to run; stop running on this core until an interrupt.
      intr_on();
      asm volatile("wfi");
    }
  }
}

// Switch to scheduler.  Must hold only p->lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&p->lock))
    panic("sched p->lock");
  if(mycpu()->noff != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(intr_get())
    panic("sched interruptible");

  intena = mycpu()->intena;
  swtch(&p->context, &mycpu()->context);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  
  struct proc *p = myproc();
  acquire(&p->lock);
  
  if(schedmode() == 1){
    // MLFQ ONLY
    int nexttq = (p -> tq) + 1;
    if(nexttq >= TIMEQUANTUM(p->qnum)){
      p -> tq = TIMEQUANTUM(p->qnum);
    }else{
      p -> tq = nexttq;
    }
    setlastpid(p->pid);
  }
  //procinfo(p);
  p->state = RUNNABLE;
  sched();
  release(&p->lock);
  //procdump();
  
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);

  if (first) {
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);

    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  // Must acquire p->lock in order to
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
  release(lk);

  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  release(&p->lock);
  acquire(lk);
}

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
        p->state = RUNNABLE;
      }
      release(&p->lock);
    }
  }
}

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->pid == pid){
      p->killed = 1;
      if(p->state == SLEEPING){
        // Wake process from sleep().
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  return -1;
}

void
setkilled(struct proc *p)
{
  acquire(&p->lock);
  p->killed = 1;
  release(&p->lock);
}

int
killed(struct proc *p)
{
  int k;
  
  acquire(&p->lock);
  k = p->killed;
  release(&p->lock);
  return k;
}

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
  struct proc *p = myproc();
  if(user_dst){
    return copyout(p->pagetable, dst, src, len);
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
  struct proc *p = myproc();
  if(user_src){
    return copyin(p->pagetable, dst, src, len);
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [USED]      "used",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
  printf("ticks : %d\n", ticks);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    printf("PID : %d | State : %s | Queue : %d | Priority : %d | TQ : %d/%d ", p->pid, state, p->qnum, p->priority, p->tq, TIMEQUANTUM(p->qnum));
    printf("\n");
  }
}


void
procinfo(struct proc *p)
{
  printf("ticks = %d, pid = %d, name =  %s \n", ticks, p->pid, p->name);
}

// 0 : FCFS
// 1 : MLFQ
int
schedmode(void)
{
  int mode;
  acquire(&schedmode_lock);
  mode = scheduler_mode;
  release(&schedmode_lock);
  return mode;
}

// 0 : FCFS
// 1 : MLFQ
int
mlfqmode(void){
  acquire(&schedmode_lock);
  if(scheduler_mode == 1){
    release(&schedmode_lock);
    return -1;
  }

  // FCFS -> MLFQ
  // Move all processes to the first queue
  for(struct proc *p = proc; p <= &proc[NPROC];){
    acquire(&p->lock);
    p->qnum = 0;
    p->tq = 0;
    p->priority = 3;
    release(&p->lock);
    p++;
  }
  scheduler_mode = 1;
  resetticks();
  release(&schedmode_lock);
  return 0;
}

int
fcfsmode(void){
  acquire(&schedmode_lock);
  if(scheduler_mode == 0){
    release(&schedmode_lock);
    return -1;
  }

  // MLFQ -> FCFS
  // Initialize all processes to FCFS
  for(struct proc *p = proc; p <= &proc[NPROC];){
    acquire(&p->lock);
    p->qnum = FCFSMODE;
    p->tq = FCFSMODE;
    p->priority = FCFSMODE;
    release(&p->lock);
    p++;
  }

  scheduler_mode = 0;
  resetticks();
  release(&schedmode_lock);
  return 0;
}

// Deprecated
// 0 : FCFS
// 1 : MLFQ
int
setschedmode(int mode)
{

  acquire(&schedmode_lock);
  if(mode == scheduler_mode){
    release(&schedmode_lock);

    return -1;
  }else{

    if(mode == 0){
      // MLFQ -> FCFS
      // Initialize all processes to FCFS
      for(struct proc *p = proc; p <= &proc[NPROC];){
        acquire(&p->lock);
        p->qnum = FCFSMODE;
        p->tq = FCFSMODE;
        p->priority = FCFSMODE;
        release(&p->lock);
        p++;
      }
    }
    else{
      // FCFS -> MLFQ
      // Move all processes to the first queue
      for(struct proc *p = proc; p <= &proc[NPROC];){
        acquire(&p->lock);
        p->qnum = 0;
        p->tq = TQ_Q0;
        p->priority = 3;
        release(&p->lock);
        p++;
      }
    }

    scheduler_mode = mode;
    resetticks();
    release(&schedmode_lock);
    return 0;
  }
}

// 0 : nothing yielded voluntarily 
// else : pid of the process that yielded on a syscall
int
yieldp(void) 
{
  int pid;
  acquire(&yieldpid_lock);
  pid = yieldpid;
  release(&yieldpid_lock);
  return pid;
}

// 0 : default(no yield)
// else : pid of the process that yielded on a syscall
int
setyieldpid(int pid) 
{
  acquire(&yieldpid_lock);
  yieldpid = pid;
  release(&yieldpid_lock);
  return yieldpid;
}

// returns lastpid
int
lastp(void){
  int pid;
  acquire(&lastpid_lock);
  pid = lastpid;
  release(&lastpid_lock);
  return pid;
}


// when yield is called, lastpid stores the pid of the process which called yield
int
setlastpid(int pid) 
{
  acquire(&lastpid_lock);
  lastpid = pid;
  release(&lastpid_lock);
  return lastpid;
}

// demote the process to the next queue
// only used in scheduler() because it assumes that the process is already in the lock
int
demoteproc(struct proc * p){
  if(p->qnum == 0){
    p->qnum = 1;
  }else if(p->qnum == 1){
    p->qnum = 2;
    p->priority = 3;

  }else if(p->qnum == 2){
    p->qnum = 2;
    int newpriority = (p->priority) - 1;

    if (newpriority < 0){
      p->priority = 0;
    }else{
      p->priority = newpriority;
    }

  }else{
    return -1;
  }

  p->tq = 0;
  return 0;
}


int
getlev(struct proc *p){
  int mode = schedmode();
  int lev;
  if(mode == 1){
    // MLFQ
    acquire(&p->lock);
    lev = p->qnum;
    release(&p->lock);
    return lev;
  }

  return 99;
}

int
setpriority(int pid, int np){

  if(np < 0 || np > 3){
    return -2;
    // invalid priority
  }

  struct proc *p;
  for(p = proc; p < &proc[NPROC];){
    acquire(&p->lock);
    if(p->pid == pid){ 
      p->priority = np; 
      release(&p->lock);  
      return 0;
    }
    release(&p->lock);
    p++;
  }

  return -1;
  // not found

}