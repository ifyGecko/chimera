default:
	as chimera.asm -o chimera.o
	ld chimera.o --oformat binary -Ttext 0x7c00 -o chimera

boot:
	make
	qemu-system-i386 -nographic chimera

clean:
	rm -f chimera.o chimera *~
