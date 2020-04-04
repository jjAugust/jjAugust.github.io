#include <lib/debug.h>
#include <dev/mboot.h>
#include "import.h"

#define PAGESIZE  4096
#define VM_USERLO 0x40000000
#define VM_USERHI 0xF0000000
#define VM_USERLO_PI  (VM_USERLO / PAGESIZE)   // VM_USERLO page index
#define VM_USERHI_PI  (VM_USERHI / PAGESIZE)   // VM_USERHI page index

void
pmem_init(pmmap_list_type *pmmap_list_p)
{
  /**
    * This variable should contain the highest available physical page number.
    * You need to calculate this value from the information in the pmmap list,
    * and save it to the nps variable before calling set_nps() function.
    */
	unsigned int nps;
	/*	
	definition:
	calculate the highest available physical page number ( NPS ) from the information in the pmmap list.
	*/
	int entries = 0,i = 0;
	unsigned int memSET[200][3];//start,end,type
	struct pmmap *pm;
	SLIST_FOREACH(pm, pmmap_list_p, next){
		// use this array to memory the start and end address, also including the type
		memSET[entries][0]=pm->start;
		memSET[entries][1]=pm->end;
		memSET[entries][2]=pm->type;
		// dprintf("start = %u\n", memSET[entries][0]);
		// dprintf("end = %u\n", memSET[entries][1]);
		// dprintf("type = %u\n", memSET[entries][2]);
		entries++;
		if(SLIST_NEXT(pm,next)== NULL){
			break;
		}
	}
	nps=pm->end/PAGESIZE+1;
	dprintf("entries = %u\n", entries);
	dprintf("nps = %u\n", nps);
	set_nps(nps);

	for (int i = 0; i < nps; ++i){
	  	if(i<VM_USERLO_PI||i>VM_USERHI_PI){
	  		set_authority_allocated(i,1,0);//kernel mode
	  	}else{
		  	for (int r = 0; r < entries; ++r)
		  	{
				if (i*PAGESIZE>=memSET[r][0]&&i*PAGESIZE+PAGESIZE-1<memSET[r][1])
				{
					memSET[r][2]==1?set_authority_allocated(i,2,0):set_authority_allocated(i,0,0);
					break;
				}else{
					set_authority_allocated(i,0,0);//unavailablel
				}
			}
		}
	}
}


