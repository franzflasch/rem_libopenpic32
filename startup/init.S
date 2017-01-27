#include <boot.h>

   /*
    * Reset vector.
    * Jump to startup code.
    */
   .section .reset,"ax",@progbits
   .set noreorder
   .ent _reset
_reset:
   j _startup
   nop

   .end _reset
   .globl _reset

   
   /*
    * Startup: executed on any reset and the non-maskable interrupt (NMI).
    */
   .section .startup,"ax",@progbits
   .set noreorder
   .ent _startup
_startup:
   
   /*
    * Check if it is a reset.
    */
   mfc0 $k0, $12, 0                 # STATUS register
   ext $k0, $k0, 19, 1              # NMI bit
   beqz $k0, _is_a_reset
   nop
   
   /*
    * NMI interrupt.
    * In the PIC32, this happens when the watchdog bites de CPU when in sleep mode.
    * Nothing to do, we just return to let CPU wakeup.
    */
   eret
   nop

_is_a_reset:
   /*
    * Start memory pointers.
    * They initial values are chosen by the linker (_stack, _gp).
    */
   la $sp, _stack
   la $gp, _gp

   mfc0    $t1, $12, 2    
   add     $t3, $t1, $0   
   ext     $t2, $t1, 26, 4
   ins     $t1, $t2, 6, 4 
   mtc0    $t1, $12, 2    
   ehb                    
   wrpgpr  $gp,$gp                  /* Change $gp in shadow registers as well */
   mtc0    $t3, $12, 2    

#ifdef IS_PIC32MZ
   /***************** CACHES INITIALIZATION ***********/

   la   $a2, init_tlb    # Generate unique EntryHi contents per entry pair.
   jalr $a2
   nop

   la   $a2, init_icache # Initialize the L1 instruction cache. (Executing using I$ on return.)
   jalr $a2
   nop

   // The changing of Kernel mode cacheability must be done from KSEG1
   // Since the code is executing from KSEG0 It needs to do a jump to KSEG1 change K0 and jump back to KSEG0
   la   $a2, change_k0_cca
   li   $a1, 0xf
   ins  $a2, $a1, 29, 1 // changed to KSEG1 address by setting bit 29
   jalr $a2
   nop

   la   $a2, init_dcache # Initialize the L1 data cache
   jalr $a2
   nop
#endif
   /***************** PREPARATION for "C" ***********/

   la $a2,     copy_c2_ram # Copy "C" code and data to RAM and zero bss (uncached.)
   jalr $a2
   nop

   /*
    * Setup co-processor (CP0)
    */
   mtc0 $0, $9, 0                # COUNT register, time zero...

   li $t2, -1
   mtc0 $t2, $11, 0              # COMPARE register, just in case

   la $t1, _ebase_address
   mtc0 $t1, $15, 1              # EBASE register points to interrupt vector table

   la $t1, _vector_spacing
   li $t2, 0
   ins $t2, $t1, 5, 5
   mtc0 $t2, $12, 1              # INTCTL register specifies vectors positions

   li $t1, 0x00800000
   mtc0 $t1, $13, 0              # CAUSE register: reset everything, set IV bit to enable vectored interrupts

   li $t1, 0
   mtc0 $t1, $12, 0              # STATUS register: reset everything: BEV = 0 (enable vectored interrupts), IPL = 0 (lowest priority run mode).

   /*
    * Startup done: call main function.
    */
   and $a0, $a0, 0
   and $a1, $a1, 0
   la $t0,main
   jr $t0
   nop   
   .end _startup
