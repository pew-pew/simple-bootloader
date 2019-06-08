[bits 32]
[extern kernel_main]

kernel_entry:
    call kernel_main
    jmp $
