.global main
.global _start

_start:
    # turn off interrupts. this means that only exceptions will be trapped.
    csrw mie, zero

    la sp, _fstack + 4
    la a0, trap_entry
    csrw mtvec, a0

    # comment out at least one flush to break the cpu
    call flush_cpu_dcache
    call flush_cpu_dcache
    call flush_cpu_dcache

    j bss_init

.global  trap_entry
.align 4
trap_entry:
    # reboot on trap if mcause != 0
    csrr x31, mcause
    beqz x31, mret
    jr zero
    mret:
    mret

bss_init:
    la a0, _fbss
    la a1, _ebss

bss_loop:
    beq a0,a1,bss_done
    sw zero,0(a0)
    add a0,a0,4
    j bss_loop

bss_done:
    call main

end_loop:
    j end_loop
