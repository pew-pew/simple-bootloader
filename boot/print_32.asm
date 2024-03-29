[bits 32]

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; eax - pointer to string
print_string_pm:
    pusha
    mov ebx, eax

    mov edx, VIDEO_MEMORY

    print_string_pm_loop:
        mov al, [ebx]
        cmp al, 0
        je print_string_pm_end

        mov ah, WHITE_ON_BLACK

        mov [edx], ax
        add edx, 2
        add ebx, 1
        jmp print_string_pm_loop

    print_string_pm_end:

    popa
    ret
