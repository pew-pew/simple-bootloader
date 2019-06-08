extern handler
global raw_interrupt_table

; underlying handler must follow cdecl calling convention
%macro interrupt_handler_body 0
    push eax
    push ecx
    push edx

    lea eax, [esp + 4 * 3] ; structure with interrupt details
    push eax
    call handler
    add esp, 4

    pop edx
    pop ecx
    pop eax
%endmacro

%macro interrupt_handler_with_EC 1
    push %1
    interrupt_handler_body
    add esp, 4
    iret
%endmacro

%macro interrupt_handler_fake_EC 1
    push 0 ; fake error code
    push %1
    interrupt_handler_body
    add esp, 8
    iret
%endmacro



%macro declare_with_EC 1
    raw_interrupt_handler_ %+ %1: interrupt_handler_with_EC %1
%endmacro

%macro declare_fake_EC 1
    raw_interrupt_handler_ %+ %1: interrupt_handler_fake_EC %1
%endmacro


declare_fake_EC 0
declare_fake_EC 1
declare_fake_EC 2
declare_fake_EC 3
declare_fake_EC 4
declare_fake_EC 5
declare_fake_EC 6
declare_fake_EC 7
declare_with_EC 8
declare_fake_EC 9
declare_with_EC 10
declare_with_EC 11
declare_with_EC 12
declare_with_EC 13
declare_with_EC 14
declare_fake_EC 15
declare_fake_EC 16
declare_with_EC 17
declare_fake_EC 18
declare_fake_EC 19
declare_fake_EC 20

%assign count 256

%assign i 21
%rep count - 21
    raw_interrupt_handler_ %+ i: interrupt_handler_fake_EC i
%assign i (i + 1)
%endrep

raw_interrupt_table:
    %assign i 0
    %rep count
        dd raw_interrupt_handler_ %+ i
    %assign i (i + 1)
    %endrep
