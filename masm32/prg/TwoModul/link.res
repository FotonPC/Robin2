SEARCH_DIR("D:\Free Pascal 2.6.4\units\i386-win32\rtl\")
SEARCH_DIR("D:\Free Pascal 2.6.4\bin\i386-win32\")
INPUT(
TwoModul.o
a_2.obj
"D:\Free Pascal 2.6.4\units\i386-win32\rtl\system.o"
"D:\Free Pascal 2.6.4\units\i386-win32\rtl\fpintres.o"
"D:\Free Pascal 2.6.4\units\i386-win32\rtl\crt.o"
"D:\Free Pascal 2.6.4\units\i386-win32\rtl\windows.o"
"D:\Free Pascal 2.6.4\units\i386-win32\rtl\objpas.o"
"D:\Free Pascal 2.6.4\units\i386-win32\rtl\sysinitpas.o"
)
GROUP(
"D:\Free Pascal 2.6.4\units\i386-win32\rtl\libimpsystem.a"
"D:\Free Pascal 2.6.4\units\i386-win32\rtl\libimpfpintres.a"
"D:\Free Pascal 2.6.4\units\i386-win32\rtl\libimpwindows.a"
"D:\Free Pascal 2.6.4\units\i386-win32\rtl\libimpsysinitpas.a"
)
SEARCH_DIR("/usr/i686-pc-cygwin/lib"); SEARCH_DIR("/usr/lib"); SEARCH_DIR("/usr/lib/w32api");
OUTPUT_FORMAT(pei-i386)
ENTRY(_mainCRTStartup)
SECTIONS
{
  . = SIZEOF_HEADERS;
  . = ALIGN(__section_alignment__);
  .text  __image_base__ + ( __section_alignment__ < 0x1000 ? . : __section_alignment__ ) :
  {
    *(.init)
    *(.text .stub .text.* .gnu.linkonce.t.*)
    *(SORT(.text$*))
    *(.glue_7t)
    *(.glue_7)
    . = ALIGN(8);
     ___CTOR_LIST__ = .; __CTOR_LIST__ = . ;
    LONG (-1);
    *(.ctors); *(.ctor); *(SORT(.ctors.*));  LONG (0);
     ___DTOR_LIST__ = .; __DTOR_LIST__ = . ;
    LONG (-1);
    *(.dtors); *(.dtor); *(SORT(.dtors.*));  LONG (0);
     *(.fini)
    PROVIDE (etext = .);
    *(.gcc_except_table)
  }
  .data BLOCK(__section_alignment__) :
  {
    __data_start__ = . ;
    *(.data .data.* .gnu.linkonce.d.* .fpc*)
    *(.data2)
    *(SORT(.data$*))
    *(.jcr)
    PROVIDE (__tls_index = .);
    LONG (0);
    __data_end__ = . ;
    *(.data_cygwin_nocopy)
  }
  .rdata BLOCK(__section_alignment__) :
  {
    *(.rdata)
    *(.rodata .rodata.* .gnu.linkonce.r.*)
    *(SORT(.rdata$*))
    *(.eh_frame)
    ___RUNTIME_PSEUDO_RELOC_LIST__ = .;
    __RUNTIME_PSEUDO_RELOC_LIST__ = .;
    *(.rdata_runtime_pseudo_reloc)
    ___RUNTIME_PSEUDO_RELOC_LIST_END__ = .;
    __RUNTIME_PSEUDO_RELOC_LIST_END__ = .;
  }
  .pdata BLOCK(__section_alignment__) : { *(.pdata) }
  .bss BLOCK(__section_alignment__) :
  {
    __bss_start__ = . ;
    *(.bss .bss.* .gnu.linkonce.b.*)
    *(SORT(.bss$*))
    *(COMMON)
    __bss_end__ = . ;
  }
  .edata BLOCK(__section_alignment__) : { *(.edata) }
  .idata BLOCK(__section_alignment__) :
  {
    SORT(*)(.idata$2)
    SORT(*)(.idata$3)
    /* These zeroes mark the end of the import list.  */
    LONG (0); LONG (0); LONG (0); LONG (0); LONG (0);
    SORT(*)(.idata$4)
    SORT(*)(.idata$5)
    SORT(*)(.idata$6)
    SORT(*)(.idata$7)
  }
  .CRT BLOCK(__section_alignment__) :
  {
    ___crt_xc_start__ = . ;
    *(SORT(.CRT$XC*))  /* C initialization */
    ___crt_xc_end__ = . ;
    ___crt_xi_start__ = . ;
    *(SORT(.CRT$XI*))  /* C++ initialization */
    ___crt_xi_end__ = . ;
    ___crt_xl_start__ = . ;
    *(SORT(.CRT$XL*))  /* TLS callbacks */
    /* ___crt_xl_end__ is defined in the TLS Directory support code */
    PROVIDE (___crt_xl_end__ = .);
    ___crt_xp_start__ = . ;
    *(SORT(.CRT$XP*))  /* Pre-termination */
    ___crt_xp_end__ = . ;
    ___crt_xt_start__ = . ;
    *(SORT(.CRT$XT*))  /* Termination */
    ___crt_xt_end__ = . ;
  }
  .tls BLOCK(__section_alignment__) :
  {
    ___tls_start__ = . ;
    *(.tls .tls.*)
    *(.tls$)
    *(SORT(.tls$*))
    ___tls_end__ = . ;
  }
  .rsrc BLOCK(__section_alignment__) :
  {
    *(.rsrc)
    *(SORT(.rsrc$*))
  }
  .reloc BLOCK(__section_alignment__) : { *(.reloc) }
  .stab BLOCK(__section_alignment__) (NOLOAD) : { *(.stab) }
  .stabstr BLOCK(__section_alignment__) (NOLOAD) : { *(.stabstr) }
  .debug_aranges BLOCK(__section_alignment__) (NOLOAD) : { *(.debug_aranges) }
  .debug_pubnames BLOCK(__section_alignment__) (NOLOAD) : { *(.debug_pubnames) }
  .debug_info BLOCK(__section_alignment__) (NOLOAD) : { *(.debug_info) *(.gnu.linkonce.wi.*) }
  .debug_abbrev BLOCK(__section_alignment__) (NOLOAD) : { *(.debug_abbrev) }
  .debug_line BLOCK(__section_alignment__) (NOLOAD) : { *(.debug_line) }
  .debug_frame BLOCK(__section_alignment__) (NOLOAD) : { *(.debug_frame) }
  .debug_str BLOCK(__section_alignment__) (NOLOAD) : { *(.debug_str) }
  .debug_loc BLOCK(__section_alignment__) (NOLOAD) : { *(.debug_loc) }
  .debug_macinfo BLOCK(__section_alignment__) (NOLOAD) : { *(.debug_macinfo) }
  .debug_weaknames BLOCK(__section_alignment__) (NOLOAD) : { *(.debug_weaknames) }
  .debug_funcnames BLOCK(__section_alignment__) (NOLOAD) : { *(.debug_funcnames) }
  .debug_typenames BLOCK(__section_alignment__) (NOLOAD) : { *(.debug_typenames) }
  .debug_varnames BLOCK(__section_alignment__) (NOLOAD) : { *(.debug_varnames) }
  .debug_ranges BLOCK(__section_alignment__) (NOLOAD) : { *(.debug_ranges) }
}
