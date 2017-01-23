/*********************************************************************
 *    Mysil tools
 *
 * Filename: SYS_Tools.h
 *
 * Description:
 *    Functions to setup memory wait states,
 *    Flash memory prefetcher and Peripheral bus divider.
 *    Helper functions for DmaSuspend and DmaResume
 */

/*********************************************************************
 * Function:       
 *    unsigned int SYSTEMConfigPerformance(unsigned int sys_clock)
 *
 * Description:
 *    The function sets the PB divider, the Flash Wait states and the DRM wait states to the optimum value.
 *    It also enables the cacheability for the K0 segment.
 *    
 * PreCondition:    
 *    None
 *
 * Parameters:           
 *    sys_clock - system clock in Hz
 *
 * Output:          
 *    the PB clock frequency in Hz
 *
 * Side Effects:    
 *    Sets the PB and Flash Wait states
 *    
 * Remarks:            
 *    The interrupts are disabled briefly, the DMA is suspended and the system is unlocked while performing the operation.
 *    Upon return the previous status of the interrupts and the DMA are restored. The system is re-locked.
 *
 * Example:
 *    <code>
 *    SYSTEMConfigPerformance(72000000);
 *    </code>
 ********************************************************************/
unsigned int SYSTEMConfigPerformance(unsigned int sys_clock);

/*
 *    Software Reset.
 */
void SoftReset(void);

/*********************************************************************
 * Function:        void cheKseg0CacheOn(void)
 *
 * PreCondition:    None
 * Input:           None
 * Output:          none
 * Side Effects:    Sets the K0 field in Config register 16 select 0, 
 *                     of Co-processor 0 to the value "011"b
 * Overview:        This routine is used to enable cacheability of KSEG0.
 *
 * Note:
 *
 ********************************************************************/
#ifdef __PIC32MX__
static inline 
void __attribute__ ((nomips16)) CheKseg0CacheOn()
{
    register unsigned long tmp;
    asm("mfc0 %0,$16,0" :  "=r"(tmp));
    tmp = (tmp & ~7) | 3;
    asm("mtc0 %0,$16,0" :: "r" (tmp));
}
#endif

/*******************************************************************************
 * Function:        int DmaSuspend(void)
 *
 * PreCondition:    None
 * Input:            None
 * Output:          true if the DMA was previously suspended, false otherwise
 *
 * Side Effects:    None
 *
 * Overview:        The function suspends the DMA controller.
 *
 * Note:            After the execution of this function the DMA operation is supposed to be suspended.
 *                  I.e. the function has to wait for the suspension to take place!
 *
 * Example:         int susp = DmaSuspend();
 ******************************************************************************/
#ifndef _DMA_H_
static __inline__ 
int __attribute__((always_inline)) DmaSuspend(void)
{
  #ifdef _DMACON_SUSPEND_MASK
    int suspSt;
    if (!(suspSt = DMACONbits.SUSPEND))    // Previous state.
    {
        DMACONSET = _DMACON_SUSPEND_MASK;    // suspend
        while((DMACONbits.DMABUSY));    // wait to be actually suspended.
    }
    return suspSt;
  #else                                    /* Some devices have no DMA. */
    return 0;
  #endif
}
#endif    // _DMA_H_

/*********************************************************************
 * Function:        void DmaResume(int susp)
 *
 * PreCondition:    None
 *
 * Input:            the desired DMA suspended state.
 *
 * Output:          None
 *
 * Side Effects:    None
 *
 * Overview:        The function restores the DMA controller activity to the old suspended mode.
 *
 * Note:            Some devices do Not have DMA.
 *
 * Example:            int susp = DmaSuspend();
 *                    {....};
 *                    DmaResume(susp);
 ******************************************************************************/
#ifndef _DMA_H_
static __inline__ 
void __attribute__((always_inline)) DmaResume(int susp)
{
  #ifdef _DMACON_SUSPEND_MASK
    if (susp)
    {
        DmaSuspend();
    }
    else
    {
        DMACONCLR = _DMACON_SUSPEND_MASK;    // resume DMA activity
    }
  #endif
}
#endif    // _DMA_H_   