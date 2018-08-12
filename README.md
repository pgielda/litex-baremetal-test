# litex-baremetal-test

To compile use the toolchain from https://github.com/riscv/riscv-tools

Please remember to patch linker.ld with a proper address to `flush_cpu_dcache`.
To get the address use `readelf -a find ./ -name bios.elf` inside LiteX directory.
It is also worth double-checking if the UART is indeed at UART_BASE.

