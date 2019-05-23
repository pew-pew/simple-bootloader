set -euxo pipefail

objdump -D -m i386 -M addr16,data16 -b binary jmp_16.bin
objdump -D -m i386 -M addr32,data32 -b binary jmp_32.bin
