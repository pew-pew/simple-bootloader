[org 0x7c00]
KERNEL_OFFSET equ 0x1000

mov bp, 0x8000
mov sp, bp

mov dh, 0x03 ; # of sectors
;mov dl, ... ; drive number, set by BIOS
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


%include "boot/real-mode/print.asm"
%include "boot/real-mode/disk.asm"
%include "boot/gdt/gdt.asm"
%include "boot/real-mode/switch.asm"
%include "boot/print_32.asm"

times 510 - ($-$$) db 0
dw 0xaa55
