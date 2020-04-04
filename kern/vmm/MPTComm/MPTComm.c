#include <lib/x86.h>

#include "import.h"


/** TASK 1:
  * * 1. Allocate a page (with container_alloc) for the page table,
  * * 2. Check if the page was allocated and register the allocated page in page directory for the given virtual address.
  * * 3. Clear (set to 0) all the page table entries for this newly mapped page table.
  * * 4. Return the page index of the newly allocated physical page.
  *    In the case when there's no physical page available, it returns 0.
  */
unsigned int alloc_ptbl(unsigned int proc_index, unsigned int vadr)
{
  // TODO
  int page_index=container_alloc(proc_index);
  if(page_index>0){
    set_pdir_entry_by_va(proc_index,vadr,page_index);
    for (int i = 0; i < 1024; ++i)
    {
      rmv_ptbl_entry(proc_index, vadr>>22, i);
    }
    return page_index;
  }else{
    return 0;
  }
}

/** TASK 2:
  * * Reverse operation of alloc_ptbl.
  *   - Remove corresponding page directory entry
  *   - Free the page for the page table entries (with container_free).
  * Hint 1: Find the pde corresponding to vadr (MPTOp layer)
  * Hint 2: Remove the pde (MPTOp layer)
  * Hint 3: Use container free
  */
void free_ptbl(unsigned int proc_index, unsigned int vadr)
{
  // TODO
  rmv_pdir_entry_by_va(proc_index,vadr);
  container_free(proc_index,get_pdir_entry_by_va(proc_index,vadr));
}

