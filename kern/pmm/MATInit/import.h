#ifndef _KERN_MM_MALINIT_H_
#define _KERN_MM_MALINIT_H_

#ifdef _KERN_

/**
 * Premitives that are already implemented in this lab.
 */
void set_nps(unsigned int); // Sets the number of available pages.
void set_authority_allocated(int page, int authority_val, int allocated_val);
unsigned int get_authority(int page);
unsigned int get_allocated(int page);
#endif /* _KERN_ */

#endif /* !_KERN_MM_MALINIT_H_ */
