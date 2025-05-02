// Mutual exclusion spin locks.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
  lk->locked = 0;
  lk->cpu = 0;
}

// Acquire the lock.
// Loops (spins) until the lock is acquired.
void
acquire(struct spinlock *lk)
{
  push_off(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // On RISC-V, sync_lock_test_and_set turns into an atomic swap:
  //   a5 = 1
  //   s1 = &lk->locked
  //   amoswap.w.aq a5, a5, (s1)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) // using atomic swap
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen strictly after the lock is acquired.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();

  // Record info about lock acquisition for holding() and debugging.
  lk->cpu = mycpu(); // every core has a cpu struct
}

// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->cpu = 0;

  // Tell the C compiler and the CPU to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other CPUs before the lock is released,
  // and that loads in the critical section occur strictly before
  // the lock is released.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();

  // Release the lock, equivalent to lk->locked = 0.
  // This code doesn't use a C assignment, since the C standard
  // implies that an assignment might be implemented with
  // multiple store instructions.
  // On RISC-V, sync_lock_release turns into an atomic swap:
  //   s1 = &lk->locked
  //   amoswap.w zero, zero, (s1)
  __sync_lock_release(&lk->locked);  //atomic swap

  pop_off(); // partner of push_off, enables interrupts
}

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
  return r;
}

// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void) // called in acquire()
{
  int old = intr_get();

  intr_off(); // Turn off interrupts.
  if(mycpu()->noff == 0) // each core has its own counter, noff. If it is the first time calling acqure(), then it is 0.
    mycpu()->intena = old; // remember the previous interrupt status
  mycpu()->noff += 1; // increment the counter
}

void
pop_off(void) // called in release()
{
  struct cpu *c = mycpu();
  if(intr_get()) // if interrupts are enabled, panic.
    panic("pop_off - interruptible");
  if(c->noff < 1) // if the counter is less than 1, panic.
    panic("pop_off");
  c->noff -= 1; // decrement the counter
  // we must remember the previous interrupt status before we started. That's in intena(interrupt enabled).
  if(c->noff == 0 && c->intena) // if there are no locked spinlocks and the previous interrupt status was enabled, then enable interrupts.
    intr_on(); // enable interrupts
}


// spinlocks should not be held for long.
// it occurs spinning waste cycles.
// => use sleep() and wakeup()

// used to protect shared data.

// acquire()
//  critical section
// release()

// In spinlock, we disable interrupts to avoid deadlock.
// In spinlock, we don't timeslice.
// After splinlock, we re-enable interrupts. 