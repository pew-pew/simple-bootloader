[org 0x7c00]

mov bp, 0x8000
mov sp, bp

mov dh, 1
mov bx, 0x8100
;mov dl, 0x80 ; expecting in drive 0
mov dl, 0 ; expecting in floppy
call disk_load


mov ax, m
call print_string

mov al, [bx]
call print_char

jmp $

m: db `ok\r\n`, 0

%include "real-mode/print.asm"
%include "real-mode/disk.asm"


;gdt_start:
;    times 4 db 0 ; empty entry
;    %include "gdt/gdt_code_segment.asm"
;    %include "gdt/gdt_data_segment.asm"
;gdt_end:
;
;gdt_table:
;    db (gdt_end - gdt_start) - 1
;    db 0
;    dw gdt_start

times 510 - ($-$$) db 0
dw 0xaa55

db 'hello'
