;org 0x7c00

start:
    jmp boot

msg: db 'Hello, world', 0

boot:
    cli
    cld
    hlt
    [bits 16]
    mov eax, ebx
    [bits 32]
    mov eax, ebx


times 510 - ($-$$) db 0
dw 0xaa55
