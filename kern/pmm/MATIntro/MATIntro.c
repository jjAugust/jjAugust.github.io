#include <lib/gcc.h>

/** ASSIGNMENT OVERVIEW:
  * ASSIGNMENT INFO:
  * - In this section, you will design and implement data-structure
  *   that performs bookkeeping for each physical page. You are
  *   free to design the data-structure to keep track of as many or
  *   as few pieces of information that you believe are essential.
  */

/** The highest available physical physical page number
  * available in the machine.
  */
static unsigned int NUM_PAGES;

/**
 * TODO: Data-Structure representing information for one physical page.
 */


struct PP_Info
{
  unsigned int authority;//0 unavailable, 1 kernel, 2 available
  unsigned int allocated;//0 unallocated, 1 allocated
};

struct PP_Info physical_page_info[1<<20];


/** The getter function for NUM_PAGES. */
unsigned int
get_nps(void)
{
  return NUM_PAGES;
}

/** The setter function for NUM_PAGES. */
void
set_nps(unsigned int nps)
{
  NUM_PAGES = nps;
}

void
set_authority_allocated( int page, int authority_val, int allocated_val){
  physical_page_info[page].authority=authority_val;
  physical_page_info[page].allocated=allocated_val;
}

unsigned int
get_authority(int page)
{
  return physical_page_info[page].authority;
}

unsigned int
get_allocated(int page)
{
  return physical_page_info[page].allocated;
}