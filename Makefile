CC = i386-elf-gcc
LD = i386-elf-ld
CC_FLAGS = -ffreestanding -fno-asynchronous-unwind-tables

KERNEL_OFFSET = 0x1000

DST = build

.PHONY: run
run: build/os_image.bin
	qemu-system-x86_64 -drive format=raw,if=floppy,file=build/os_image.bin

build/kernel.o: kernel.c
	$(CC) $(CC_FLAGS) kernel.c -c -o build/kernel.o

build/kernel_entry.o: kernel_entry.asm
	nasm -f elf kernel_entry.asm -o build/kernel_entry.o

build/kernel.bin: build/kernel_entry.o build/kernel.o
	$(LD) build/kernel_entry.o build/kernel.o \
		--oformat binary -Ttext $(KERNEL_OFFSET) -o build/kernel.bin

build/boot_sector.bin: boot_sector.asm
	nasm -f bin boot_sector.asm -o build/boot_sector.bin

build/os_image.bin: build/boot_sector.bin build/kernel.bin
	cat build/boot_sector.bin build/kernel.bin > build/os_image.bin
