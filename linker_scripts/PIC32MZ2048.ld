
/*
 * Microchip PIC32MX210F016B.
 * Linker Script.
 * See device documentation.
 */

/* Important to use elf32-tradlittlemips, if set to other format strange effects occure when linking:
 * undefined symbols are simply ignored when using elf32-little, no idea why
 */
OUTPUT_FORMAT("elf32-tradlittlemips")
OUTPUT_ARCH("mips")
ENTRY(_reset)

/*
 * Interrupt vector static definitions.
 */
PROVIDE(_vector_spacing = 0x00000001);
PROVIDE(_ebase_address = 0x9FC72000);

_RESET_ADDR              = 0x9FC00000;

/*
 * PIC32MX695F512H memory map.
 */
MEMORY
{
  program_mem (rx)           : ORIGIN = 0x9D000000, LENGTH = 0x80000       /* flash program memory */
  boot_mem                   : ORIGIN = 0x9FC00000, LENGTH = 0x72000       /* special flash boot memory */
                                                                          /* length overall is 0xBF0, 
                                                                           * but we reduce it by the length of the
                                                                           * vector table */
  vectors_mem                : ORIGIN = 0x9FC72000, LENGTH = 0x2000        /* interrupt vectors area */
  config3_mem                : ORIGIN = 0x9FC0FFC0, LENGTH = 0x4           /* configuration bits */
  config2_mem                : ORIGIN = 0x9FC0FFC4, LENGTH = 0x4
  config1_mem                : ORIGIN = 0x9FC0FFC8, LENGTH = 0x4
  config0_mem                : ORIGIN = 0x9FC0FFCC, LENGTH = 0x4
  config_cp0                 : ORIGIN = 0x9FC0FFDC, LENGTH = 0x4
  data_mem (wx)              : ORIGIN = 0x80000000, LENGTH = 0x20000       /* ram memory */
  sfrs_mem                   : ORIGIN = 0xBF800000, LENGTH = 0x100000     /* special function registers */
}

/*
 * Lets place the sections into memory.
 */
SECTIONS
{
  /*
   * PIC32 configuration bits.
   */
  .devcfg0 : { KEEP(*(.devcfg0)) } > config0_mem
  .devcfg1 : { KEEP(*(.devcfg1)) } > config1_mem
  .devcfg2 : { KEEP(*(.devcfg2)) } > config2_mem
  .devcfg3 : { KEEP(*(.devcfg3)) } > config3_mem
  .devcp0 : { KEEP(*(.devcp0)) } > config_cp0

  /*
   * reset vector.
   */
  .reset _RESET_ADDR :
  {
    KEEP(*(.reset))
    KEEP(*(.reset.startup))
  } > boot_mem
  
  /*
   * Interrupt vectors.
   * They are 64 small code segments in sequence.
   */
  .vector_0 _ebase_address + 0x200 :
  { KEEP(*(.vector_0)) } > vectors_mem
  
  .vector_1 _ebase_address + 0x200 + (_vector_spacing << 5) * 1 :
  { KEEP(*(.vector_1)) } > vectors_mem
  
  .vector_2 _ebase_address + 0x200 + (_vector_spacing << 5) * 2 :
  { KEEP(*(.vector_2)) } > vectors_mem
  
  .vector_3 _ebase_address + 0x200 + (_vector_spacing << 5) * 3 :
  { KEEP(*(.vector_3)) } > vectors_mem
  
  .vector_4 _ebase_address + 0x200 + (_vector_spacing << 5) * 4 :
  { KEEP(*(.vector_4)) } > vectors_mem
  
  .vector_5 _ebase_address + 0x200 + (_vector_spacing << 5) * 5 :
  { KEEP(*(.vector_5)) } > vectors_mem
  
  .vector_6 _ebase_address + 0x200 + (_vector_spacing << 5) * 6 :
  { KEEP(*(.vector_6)) } > vectors_mem
  
  .vector_7 _ebase_address + 0x200 + (_vector_spacing << 5) * 7 :
  { KEEP(*(.vector_7)) } > vectors_mem
  
  .vector_8 _ebase_address + 0x200 + (_vector_spacing << 5) * 8 :
  { KEEP(*(.vector_8)) } > vectors_mem
  
  .vector_9 _ebase_address + 0x200 + (_vector_spacing << 5) * 9 :
  { KEEP(*(.vector_9)) } > vectors_mem
  
  .vector_10 _ebase_address + 0x200 + (_vector_spacing << 5) * 10 :
  { KEEP(*(.vector_10)) } > vectors_mem
  
  .vector_11 _ebase_address + 0x200 + (_vector_spacing << 5) * 11 :
  { KEEP(*(.vector_11)) } > vectors_mem
  
  .vector_12 _ebase_address + 0x200 + (_vector_spacing << 5) * 12 :
  { KEEP(*(.vector_12)) } > vectors_mem
  
  .vector_13 _ebase_address + 0x200 + (_vector_spacing << 5) * 13 :
  { KEEP(*(.vector_13)) } > vectors_mem
  
  .vector_14 _ebase_address + 0x200 + (_vector_spacing << 5) * 14 :
  { KEEP(*(.vector_14)) } > vectors_mem
  
  .vector_15 _ebase_address + 0x200 + (_vector_spacing << 5) * 15 :
  { KEEP(*(.vector_15)) } > vectors_mem
  
  .vector_16 _ebase_address + 0x200 + (_vector_spacing << 5) * 16 :
  { KEEP(*(.vector_16)) } > vectors_mem
  
  .vector_17 _ebase_address + 0x200 + (_vector_spacing << 5) * 17 :
  { KEEP(*(.vector_17)) } > vectors_mem
  
  .vector_18 _ebase_address + 0x200 + (_vector_spacing << 5) * 18 :
  { KEEP(*(.vector_18)) } > vectors_mem
  
  .vector_19 _ebase_address + 0x200 + (_vector_spacing << 5) * 19 :
  { KEEP(*(.vector_19)) } > vectors_mem
  
  .vector_20 _ebase_address + 0x200 + (_vector_spacing << 5) * 20 :
  { KEEP(*(.vector_20)) } > vectors_mem
  
  .vector_21 _ebase_address + 0x200 + (_vector_spacing << 5) * 21 :
  { KEEP(*(.vector_21)) } > vectors_mem
  
  .vector_22 _ebase_address + 0x200 + (_vector_spacing << 5) * 22 :
  { KEEP(*(.vector_22)) } > vectors_mem
  
  .vector_23 _ebase_address + 0x200 + (_vector_spacing << 5) * 23 :
  { KEEP(*(.vector_23)) } > vectors_mem
  
  .vector_24 _ebase_address + 0x200 + (_vector_spacing << 5) * 24 :
  { KEEP(*(.vector_24)) } > vectors_mem
  
  .vector_25 _ebase_address + 0x200 + (_vector_spacing << 5) * 25 :
  { KEEP(*(.vector_25)) } > vectors_mem
  
  .vector_26 _ebase_address + 0x200 + (_vector_spacing << 5) * 26 :
  { KEEP(*(.vector_26)) } > vectors_mem
  
  .vector_27 _ebase_address + 0x200 + (_vector_spacing << 5) * 27 :
  { KEEP(*(.vector_27)) } > vectors_mem
  
  .vector_28 _ebase_address + 0x200 + (_vector_spacing << 5) * 28 :
  { KEEP(*(.vector_28)) } > vectors_mem
  
  .vector_29 _ebase_address + 0x200 + (_vector_spacing << 5) * 29 :
  { KEEP(*(.vector_29)) } > vectors_mem
  
  .vector_30 _ebase_address + 0x200 + (_vector_spacing << 5) * 30 :
  { KEEP(*(.vector_30)) } > vectors_mem
  
  .vector_31 _ebase_address + 0x200 + (_vector_spacing << 5) * 31 :
  { KEEP(*(.vector_31)) } > vectors_mem
  
  .vector_32 _ebase_address + 0x200 + (_vector_spacing << 5) * 32 :
  { KEEP(*(.vector_32)) } > vectors_mem
  
  .vector_33 _ebase_address + 0x200 + (_vector_spacing << 5) * 33 :
  { KEEP(*(.vector_33)) } > vectors_mem
  
  .vector_34 _ebase_address + 0x200 + (_vector_spacing << 5) * 34 :
  { KEEP(*(.vector_34)) } > vectors_mem
  
  .vector_35 _ebase_address + 0x200 + (_vector_spacing << 5) * 35 :
  { KEEP(*(.vector_35)) } > vectors_mem
  
  .vector_36 _ebase_address + 0x200 + (_vector_spacing << 5) * 36 :
  { KEEP(*(.vector_36)) } > vectors_mem
  
  .vector_37 _ebase_address + 0x200 + (_vector_spacing << 5) * 37 :
  { KEEP(*(.vector_37)) } > vectors_mem
  
  .vector_38 _ebase_address + 0x200 + (_vector_spacing << 5) * 38 :
  { KEEP(*(.vector_38)) } > vectors_mem
  
  .vector_39 _ebase_address + 0x200 + (_vector_spacing << 5) * 39 :
  { KEEP(*(.vector_39)) } > vectors_mem
  
  .vector_40 _ebase_address + 0x200 + (_vector_spacing << 5) * 40 :
  { KEEP(*(.vector_40)) } > vectors_mem
  
  .vector_41 _ebase_address + 0x200 + (_vector_spacing << 5) * 41 :
  { KEEP(*(.vector_41)) } > vectors_mem
  
  .vector_42 _ebase_address + 0x200 + (_vector_spacing << 5) * 42 :
  { KEEP(*(.vector_42)) } > vectors_mem
  
  .vector_43 _ebase_address + 0x200 + (_vector_spacing << 5) * 43 :
  { KEEP(*(.vector_43)) } > vectors_mem
  
  .vector_44 _ebase_address + 0x200 + (_vector_spacing << 5) * 44 :
  { KEEP(*(.vector_44)) } > vectors_mem
  
  .vector_45 _ebase_address + 0x200 + (_vector_spacing << 5) * 45 :
  { KEEP(*(.vector_45)) } > vectors_mem
  
  .vector_46 _ebase_address + 0x200 + (_vector_spacing << 5) * 46 :
  { KEEP(*(.vector_46)) } > vectors_mem
  
  .vector_47 _ebase_address + 0x200 + (_vector_spacing << 5) * 47 :
  { KEEP(*(.vector_47)) } > vectors_mem
  
  .vector_48 _ebase_address + 0x200 + (_vector_spacing << 5) * 48 :
  { KEEP(*(.vector_48)) } > vectors_mem
  
  .vector_49 _ebase_address + 0x200 + (_vector_spacing << 5) * 49 :
  { KEEP(*(.vector_49)) } > vectors_mem
  
  .vector_50 _ebase_address + 0x200 + (_vector_spacing << 5) * 50 :
  { KEEP(*(.vector_50)) } > vectors_mem
  
  .vector_51 _ebase_address + 0x200 + (_vector_spacing << 5) * 51 :
  { KEEP(*(.vector_51)) } > vectors_mem
  
  .vector_52 _ebase_address + 0x200 + (_vector_spacing << 5) * 52 :
  { KEEP(*(.vector_52)) } > vectors_mem
  
  .vector_53 _ebase_address + 0x200 + (_vector_spacing << 5) * 53 :
  { KEEP(*(.vector_53)) } > vectors_mem
  
  .vector_54 _ebase_address + 0x200 + (_vector_spacing << 5) * 54 :
  { KEEP(*(.vector_54)) } > vectors_mem
  
  .vector_55 _ebase_address + 0x200 + (_vector_spacing << 5) * 55 :
  { KEEP(*(.vector_55)) } > vectors_mem
  
  .vector_56 _ebase_address + 0x200 + (_vector_spacing << 5) * 56 :
  { KEEP(*(.vector_56)) } > vectors_mem
  
  .vector_57 _ebase_address + 0x200 + (_vector_spacing << 5) * 57 :
  { KEEP(*(.vector_57)) } > vectors_mem
  
  .vector_58 _ebase_address + 0x200 + (_vector_spacing << 5) * 58 :
  { KEEP(*(.vector_58)) } > vectors_mem
  
  .vector_59 _ebase_address + 0x200 + (_vector_spacing << 5) * 59 :
  { KEEP(*(.vector_59)) } > vectors_mem
  
  .vector_60 _ebase_address + 0x200 + (_vector_spacing << 5) * 60 :
  { KEEP(*(.vector_60)) } > vectors_mem
  
  .vector_61 _ebase_address + 0x200 + (_vector_spacing << 5) * 61 :
  { KEEP(*(.vector_61)) } > vectors_mem
  
  .vector_62 _ebase_address + 0x200 + (_vector_spacing << 5) * 62 :
  { KEEP(*(.vector_62)) } > vectors_mem
  
  .vector_63 _ebase_address + 0x200 + (_vector_spacing << 5) * 63 :
  { KEEP(*(.vector_63)) } > vectors_mem

  /*
   * Startup code from init.s.
   */
  .startup :
  {
    KEEP(*(.startup))
  } > boot_mem

  /*
   * Text segment: program code, to the Flash.
   */
  .text :
  {
    PROVIDE(_ftext = .) ;
    *(.text .stub .text.* .gnu.linkonce.t.*)
    . = ALIGN(4) ;
    PROVIDE (_etext = .);
  } >program_mem

  /*
   * Constants: to the Flash.
   */
  .rodata ALIGN(4):
  {
    *( .rodata .rodata.* .gnu.linkonce.r.*)
    *(.rodata1)
  } >program_mem

  .sdata2 ALIGN(4): { *(.sdata2 .sdata2.* .gnu.linkonce.s2.*) } >program_mem
  .sbss2 ALIGN(4):  { *(.sbss2 .sbss2.* .gnu.linkonce.sb2.*)  }  >program_mem
  .eh_frame_hdr ALIGN(4): { *(.eh_frame_hdr) }  >program_mem
  .eh_frame ALIGN(4): ONLY_IF_RO { KEEP (*(.eh_frame)) }  >program_mem

  . = ALIGN(4) ;
  rodata_end = . ;
  
  /*
   * Initialized Data segments, from Flash to RAM.
   */
  .data : AT (rodata_end)
  {
    PROVIDE(_fdata = .) ;
    *(.data .data.* .gnu.linkonce.d.*)
    *(.data1)
  } >data_mem

  _gp = ALIGN(16) + 0x7ff0;                           /* place gp next to data and small data */
  .got ALIGN(4) :
  {
     *(.got.plt) *(.got)
  } >data_mem 

  .sdata ALIGN(4) :
  {
    *(.sdata .sdata.* .gnu.linkonce.s.*)
  } >data_mem

  .lit8 : { *(.lit8) } >data_mem
  .lit4 : { *(.lit4) } >data_mem
  .eh_frame ALIGN(4): ONLY_IF_RW { KEEP (*(.eh_frame)) } >data_mem

  . = ALIGN (4) ;
  PROVIDE(_edata = .);
  PROVIDE(_fimage = LOADADDR(.data));                 /* address of the data image in flash */
  . = .;

  /*
   * Unitialized data segments, RAM only.
   */
  PROVIDE(_fbss = .);
  .sbss ALIGN(4) :
  {
    *(.dynsbss)
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.scommon)
  } >data_mem
  
  .bss ALIGN(4) :
  {
   *(.dynbss)
   *(.bss .bss.* .gnu.linkonce.b.*)
   *(COMMON)
    . = ALIGN(32 / 8) ;
  } >data_mem
  . = ALIGN(4);
  PROVIDE(_ebss = .);
  
  /*
   * End of static data. To be used for dynamic data.
   */
  _end = .; PROVIDE (end = .);
  _heap = . ;

  /*
   * Move to the end to place the stack pointer.
   */
  . = ADDR(.data) + LENGTH(data_mem) - 4 ;
  . = ALIGN(4) ;
  _stack = . ;
}
