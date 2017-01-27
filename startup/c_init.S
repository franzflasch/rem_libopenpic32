#include <boot.h>

  .set  noreorder           # Don't allow the assembler to reorder instructions.
  .set  noat                # Don't allow the assembler to use r1(at) for synthetic instr.

/**************************************************************************************
DATA BSS Initialization
**************************************************************************************/
LEAF_IN_SECTION(copy_c2_ram, startup)

    # Copy code and read-only/initialized data from FLASH to (uncached) RAM.
    la      $a1, _fimage
    la      $a2, _fdata
    la      $a3, _edata

    beq     $a2, $a3, zero_bss
    nop

next_ram_word:
    lw      $a0, 0($a1)
    sw      $a0, 0($a2)
    addiu   $a2, 4
    bne     $a3, $a2, next_ram_word
    addiu   $a1, 4

zero_bss:
    la      $a2, _fbss
    la      $a3, _ebss
    beq     $a2, $a3, copy_c2_ram_done
    nop
next_bss_word:
    sw      $0, 0($a2)
    addiu   $a2, 4
    bne     $a2, $a3, next_bss_word
    nop

copy_c2_ram_done:
    jalr  $0,      $31  /* 31 is ra register (probably return address) */
    nop

.set at
END(copy_c2_ram)
