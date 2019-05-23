[bits 16]
switch_to_protected:
    cli ; disable interrupts
    lgdt [gdt]

    mov eax, cr0
    or eax, 0b1
    mov cr0, eax

    jmp CODE_SEG:begin_protected

[bits 32]
begin_protected:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    call BEGIN_PM
