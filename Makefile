CPUFLAGS 	= -D__vexriscv__ -march=rv32im  -mabi=ilp32
COMMONFLAGS = -Os $(CPUFLAGS) -g3 -fomit-frame-pointer -Wall -fno-builtin -nostdinc
CFLAGS 		= $(COMMONFLAGS) -fexceptions -Wstrict-prototypes -Wold-style-definition -Wmissing-prototypes
LDFLAGS 	= $(CPUFLAGS) -nostdlib -nodefaultlibs

CC := riscv64-unknown-elf-gcc -std=gnu99
OBJCOPY := riscv64-unknown-elf-objcopy
OBJDUMP := riscv64-unknown-elf-objdump
LD := $(CC)

all: test.bin test.dump

test.bin: test.elf
	$(OBJCOPY) -O binary $< $@
	chmod -x $@

test.dump: test.elf
	$(OBJDUMP) -S $< > $@

test.elf: crt0-vexriscv.o main.o
	$(LD) $(LDFLAGS) -T linker.ld -N -o $@ $^

%.o: %.c
	$(CC) -c $(CFLAGS) -o $@ $<

%.o: %.S
	$(CC) -c $(CFLAGS) -o $@ $<

clean:
	rm *.o *.elf *.bin *.dump

.PHONY: all clean
