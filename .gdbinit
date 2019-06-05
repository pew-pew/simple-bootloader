symbol-file build/kernel.elf
break main
target remote localhost:1234
continue
layout src
focus cmd
