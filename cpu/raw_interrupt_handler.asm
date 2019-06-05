bits 32

global raw_interrupt_handler
extern handler

raw_interrupt_handler:
    call handler
    iret
