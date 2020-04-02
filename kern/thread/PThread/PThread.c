#include <lib/x86.h>
#include <lib/thread.h>

#include "import.h"

void thread_init(void)
{
	tqueue_init();
	set_curid(0);
	tcb_set_state(0, TSTATE_RUN);
}

/** TASK 1:
  * * Allocate new child thread context, set the state of the new child thread
  *   as ready, and push it to the ready queue.
  *   It returns the child thread id.
  *  Hint 1:
  *  - import.h has all the functions you will need.
  *  Hint 2:
  *  - The ready queue is the queue with index NUM_IDS. 
  */
unsigned int thread_spawn(void *entry, unsigned int id, unsigned int quota)
{
  // TODO
  return 0;
}

/** TASK 2:
  * * Yield to the next thread in the ready queue. You should:
  *   - Set the currently running thread state as ready,
  *     and push it back to the ready queue.
  *   - Set the state of the poped thread as running
  *   - Set the current thread id
  *   - Then switch to the new kernel context by calling:
  *     kctx_switch(curid, next) as shown in the last statement (given)
  *   
  *  Hint 1: The next thread to run is chosen in a round-robin fashion.
  *          i.e. The thread at the head of the ready queue is run next.
  *  Hint 2: If you are the only thread that is ready to run,
  *          do you need to switch to yourself?
  */
void thread_yield(void)
{
  unsigned int curid, next; 

  // TODO
  // ...
  
  // Check to make sure there is another thread to yield to.
  if (next != NUM_IDS) {
    // TODO
    // ...

    // This performs the switch.
    kctx_switch(curid, next);
  } 
}