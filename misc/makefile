all:
	echo "Specify target"

flags = -ffreestanding \
		-fno-asynchronous-unwind-tables

sample.o: sample.c
	i386-elf-gcc $(flags) -c sample.c -o sample.o

sample.bin: sample.o
	i386-elf-ld sample.o -Ttext 0x0 --oformat binary -o sample.bin

dump: sample.bin
	objdump -D -m i386 -M addr32,data32 -b binary sample.bin

clean:
	rm -f -v sample.o
