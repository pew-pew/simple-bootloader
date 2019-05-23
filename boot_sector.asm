[org 0x7c00]

mov bp, 0x9000
mov sp, bp

mov ax, hi_msg
call print_string

jmp switch

%include "gdt/gdt.asm"
%include "real-mode/print.asm"

[bits 16]
switch:
    cli ; disable interrupts
    lgdt [gdt]


    mov eax, cr0
    or eax, 0b1
    mov cr0, eax

    jmp CODE_SEG:entered

[bits 32]
entered:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    call BEGIN_PM

BEGIN_PM:
    mov ebx, hi_msg
    call print_string_pm

    jmp $

%include "print_32.asm"

[bits 16]


hi_msg:
    db 'Entering real mode...', `\r\n`, 0

times 510 - ($-$$) db 0
dw 0xaa55
