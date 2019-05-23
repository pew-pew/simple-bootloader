[org 0x7c00]

mov ax, 0xff

jmp switch_to_protected

%include "gdt/gdt.asm"
%include "real-mode/print.asm"
%include "switch.asm"

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
