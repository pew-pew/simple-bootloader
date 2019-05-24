; Intel software developer manual
; Vol. 3A 9-13

; Page 325 of
; https://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-vol-3a-part-1-manual.pdf

[bits 16]
switch_to_protected:
    cli ; disable interrupts
    lgdt [gdt]

    mov eax, cr0
    or eax, 0b1
    mov cr0, eax ; enable protected mode

    jmp CODE_SEG:begin_protected

[bits 32]
begin_protected:
    ; ltr?

    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    jmp BEGIN_PM
    jmp $ ; never return here, please
