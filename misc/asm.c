int foo(int arg) {
    int out;
    __asm__("mov %1, %0" : "=r" (out) : "r" (arg));
    return out + arg;
}
