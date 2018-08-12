OUTPUT_FORMAT("elf32-littleriscv")
ENTRY(_start)

MEMORY {
	rom : ORIGIN = 0x00000000, LENGTH = 0x00008000
	sram : ORIGIN = 0x10000000, LENGTH = 0x00008000
	main_ram : ORIGIN = 0x40000000, LENGTH = 0x10000000
}

SECTIONS
{
	.text :
	{
		_ftext = .;
		*(.text .stub .text.* .gnu.linkonce.t.*)
		_etext = .;
	} > main_ram 

	.rodata :
	{
		. = ALIGN(4);
		_frodata = .;
		*(.rodata .rodata.* .gnu.linkonce.r.*)
		*(.rodata1)
		_erodata = .;
	} > main_ram

	.data :
	{
		. = ALIGN(4);
		_fdata = .;
		*(.data .data.* .gnu.linkonce.d.*)
		*(.data1)
		*(.sdata .sdata.* .gnu.linkonce.s.*)
		_edata = .;
	} > main_ram

	.bss :
	{
		. = ALIGN(4);
		_fbss = .;
		*(.dynsbss)
		*(.sbss .sbss.* .gnu.linkonce.sb.*)
		*(.scommon)
		*(.dynbss)
		*(.bss .bss.* .gnu.linkonce.b.*)
		*(COMMON)
		. = ALIGN(4);
		_ebss = .;
		 . = ALIGN(8);
                _heapstart = .;
		_end = .;
	} > main_ram

	/DISCARD/ :
	{
		*(.eh_frame)
		*(.comment)
	}
}

PROVIDE(trap_entry = 0x40);
PROVIDE(_fstack = ORIGIN(main_ram) + LENGTH(main_ram) - 4);
PROVIDE(flush_cpu_dcache = 0x2b7c);
