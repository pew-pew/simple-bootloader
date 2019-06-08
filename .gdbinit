symbol-file build/kernel.elf
break kernel_main
target remote localhost:1234
continue
layout src
focus cmd

#layout asm
#layout regs
#until 35
