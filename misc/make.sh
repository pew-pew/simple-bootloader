set -euxo pipefail


nasm -f bin boot_sector.asm -g -o boot_sector.img

#objdump -D -m i386 -M addr16,data16 -b binary boot_sector.img


i386-elf-gcc -ffreestanding -fno-asynchronous-unwind-tables \
    kernel.c -c -o kernel.o

nasm kernel_entry.asm -f elf -o kernel_entry.o

i386-elf-ld -Ttext 0x1000 --oformat binary \
    kernel_entry.o kernel.o \
    -o kernel.bin

cat boot_sector.img kernel.bin > os-image.bin


qemu-system-x86_64 \
    -drive format=raw,if=floppy,file=os-image.bin \
    #-monitor telnet:127.0.0.1:1234,server,nowait \
    #-S \
    #-s &

#gdb

#kill -s SIGINT %1
