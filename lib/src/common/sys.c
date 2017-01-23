/*********************************************************************
 *    Mysil tools
 *
 * Filename: SYS_Setup.c
 *
 * Description:
 *    Functions to setup memory wait states,
 *    Flash memory prefetcher and Peripheral bus divider.
 */
#include <sys.h>
#include <sfr.h>

#if defined    __PIC32MX__
  #define FLASH_SPEED_HZ        30000000 // Max Flash speed
  #define PB_BUS_MAX_FREQ_HZ    80000000 // Max Peripheral bus speed
//  #define PB_BUS_MAX_FREQ_HZ    20000000 // Temporary try.

#elif defined    __PIC32MZ__
  #define FLASH_SPEED_HZ        67000000 // Max Flash speed
  #define PB_BUS_MAX_FREQ_HZ   100000000 // Max Peripheral bus speed
#endif
/*    Note:
 *        On 100 MHz MX devices, max peripheral bus frequency may be 100 MHz.
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
unsigned int SYSTEMConfigPerformance(unsigned int sys_clock)
{
    unsigned int pb_clock;
//    unsigned int int_status;

/*    Save current DMA state and suspend the activity. */
    DmaSuspend();
    pb_clock = sys_clock;

  #ifdef        __PIC32MZ
/*    PIC32MZ have multiple Peripheral buses, each with its own divider control.
    Peripheral bus dividers in PIC32MZ are set for 1/2 ratio by device reset. */
    pb_clock >>= 1;

  #elif defined    __PIC32MX__
    {
        __OSCCONbits_t oscBits;
        unsigned int pb_div = 0;

        while (pb_clock > PB_BUS_MAX_FREQ_HZ)
        {   pb_div += 1;
            pb_clock >>= 1;
        }
    /*    Unlock sequence. */
        {    SYSKEY = 0; SYSKEY = 0xAA996655; SYSKEY = 0x556699AA;
        } while(0);

        oscBits.w = OSCCON;        /* Read OSCCON register to be in sync. flush any pending write. */
        oscBits.PBDIV = pb_div;    /* Insert Peripheral Bus divider value. */
        OSCCON = oscBits.w;        /* Write back to register. */
        oscBits.w = OSCCON;        /* make sure the write occurred before returning. */
    }
  #endif

/*    Set flash wait states based on
 *    Clock frequency / Flash speed.
 */
  #ifdef _PCACHE                
    {    unsigned int wait_states = 0;
        unsigned int tmp_clock = sys_clock;

        while(tmp_clock > FLASH_SPEED_HZ)
        {   wait_states++;
            tmp_clock -= FLASH_SPEED_HZ;
        }
        CHECONSET = (wait_states << _CHECON_PFMWS_POSITION) & _CHECON_PFMWS_MASK;
        CHECONCLR =(~wait_states << _CHECON_PFMWS_POSITION) & _CHECON_PFMWS_MASK;

    /*    Invalidate Cache if Flash Memory is programmed. */
        CHECONSET = _CHECON_CHECOH_MASK;

    /*    Enable Instruction Prefetcher */
        CHECONSET = 3 << _CHECON_PREFEN_POSITION;

    /*    Enable Kseg0 cache in MIPS core. */
        CheKseg0CacheOn();
    }

/*    On PIC32MZ, Cache is integrated in CPU, and is enabled in Startup code.
    It also have Instruction Prefetcher in interface to Program Flash memory.*/
  #elif defined    __PIC32MZ__ && defined _PRECON_PFMWS_MASK
    {    unsigned int wait_states = 0;
        unsigned int tmp_clock = sys_clock;

        while(tmp_clock > FLASH_SPEED_HZ)
        {   wait_states++;
            tmp_clock -= FLASH_SPEED_HZ;
        }
        PRECONSET = (wait_states << _PRECON_PFMWS_POSITION) & _PRECON_PFMWS_MASK;
        PRECONCLR =(~wait_states << _PRECON_PFMWS_POSITION) & _PRECON_PFMWS_MASK;

    /*    Enable Instruction Prefetcher */
        PRECONSET = 3 << _PRECON_PREFEN_POSITION;
    }
  #endif

/*    Set Data RAM Memory wait state to the optimum value.
 *    This control exists in all PIC32MX */
  #ifdef _BMXCON_BMXWSDRM_MASK
    BMXCONCLR = _BMXCON_BMXWSDRM_MASK;
  #endif

    SYSKEY = 0;            /* Set System Lock. */

    return pb_clock;
}