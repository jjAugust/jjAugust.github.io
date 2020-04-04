#ifndef _KERN_MM_MALOP_H_
#define _KERN_MM_MALOP_H_

#ifdef _KERN_

/**
 * You can import functions (if any) from MATIntro here.
 */

/** The highest page number of available physical pages. */
unsigned int get_nps(void);
void set_authority_allocated(int page, int authority_val, int allocated_val);
unsigned int get_authority(int page);
unsigned int get_allocated(int page);
#endif /* _KERN_ */

#endif /* !_KERN_MM_MALOP_H_ */
