[org 0x7c00]
KERNEL_OFFSET equ 0x1000

mov bp, 0x8000
mov sp, bp

mov dh, 0xf ; # of sectors
mov dl, 0x0 ; drive number, 1st floppy
mov bx, KERNEL_OFFSET ; output
call disk_load

mov ax, real_mode_msg
call real_print_string

jmp switch_to_protected

[bits 32]
BEGIN_PM:
    mov eax, protected_mode_msg
    call print_string_pm

    call KERNEL_OFFSET

    jmp $

real_mode_msg:
    db 'In real mode, entering protected mode...', `\r\n`, 0

protected_mode_msg:
    db 'Entered protected mode!', 0


%include "real-mode/print.asm"
%include "real-mode/disk.asm"
%include "gdt/gdt.asm"
%include "real-mode/switch.asm"
%include "print_32.asm"

times 510 - ($-$$) db 0
dw 0xaa55
