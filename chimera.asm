    .code16
    .global _start

_start:
elf32_ehdr:
e_ident:
        .byte 0x7f, 'E', 'L', 'F', 0x1, 0x2, 0x1, 0x1
        .word 0xc025, 0xc024, 0xc023, 0xc022
e_type:
        .word 0x2
e_machine:
        .word 0x3
e_version:
        .word 0x1, 0x0
e_entry:
        .word 0x00172, 0x804
e_phoff:
        .word 0x34, 0x0
e_shoff:
        .word 0x0, 0x0
e_flags:
        .word 0x0, 0x0
e_ehsize:
        .word 0x34
e_phentsize:
        .word 0x20
e_phnum:
        .word 0x1
e_shentsize:
        .word 0x20
e_shnum:
        .word 0x0
e_shstrndx:
        .word 0x0

elf32_phdr:
p_type:
        .word 0x1, 0x0
p_offset:
        .word 0x0000, 0x0
P_vaddr:
        .word 0x0000, 0x804
p_paddr:
        .word 0x0000, 0x804
P_filesz:
        .word 0x200, 0x0000
p_memsz:
        .word 0xebc0, 0x003b
p_flags:
        .word 0x7, 0x0
p_align:
        .word 0x1000, 0x0

tiny85:
        .word 0xe082
        .word 0xbb87
        .word 0x2411
        .word 0xbc1a
        .word 0xbe13
        .word 0xb643
        .word 0x6085
        .word 0xbf83
        .word 0xbe12
        .word 0x9ac1
        .word 0xd003
        .word 0x98c1
        .word 0xd001
        .word 0xcffb
        .word 0xe38e
        .word 0xe090
        .word 0xb608
        .word 0xfe01
        .word 0xcffd
        .word 0xb728
        .word 0x6022
        .word 0xbf28
        .word 0x9701
        .word 0xf7c1
        .word 0x9508

boot:
        mov $msg, %si
        mov $0x13, %bl
print:
        lodsb
        cmp $0, %al
        je  done
        mov %al, %cl
        and %bl, %al
        mov $-2, %dl
        mul %dl
        add %cl, %al
        add %bl, %al
        mov $0xe, %ah
        int $0x10
        jmp print
done:
        hlt
msg:
        .byte 0x72, 0x67, 0x33, 0x67, 0x7a, 0x7d, 0x6a, 0x33, 0x35, 0x33, 0x2b, 0x26, 0x3f, 0x33, 0x64, 0x7b, 0x72, 0x67, 0x33, 0x7a, 0x60, 0x33, 0x67, 0x7b, 0x76, 0x33, 0x75, 0x61, 0x76, 0x62, 0x66, 0x76, 0x7d, 0x70, 0x6a, 0x33, 0x7a, 0x7d, 0x33, 0x7a, 0x76, 0x76, 0x76, 0x24, 0x26, 0x27, 0x33, 0x60, 0x7a, 0x7d, 0x74, 0x7f, 0x76, 0x33, 0x63, 0x61, 0x76, 0x70, 0x7a, 0x60, 0x7a, 0x7c, 0x7d, 0x2c, 0x00


        .code32
_print:
        xchg %eax, %edi
        mov $4, %eax
        mov $1, %ebx
        mov $0x804010b, %ecx
        mov %ecx, %edx
decode:
        xor %edi, (%edx)
        lea 4(%edx), %edx
        cmp $0x804013b, %edx
        jl decode
        mov $48, %edx
        int $0x80
_exit:
        hlt

hint:
        .byte 0x7c, 0x77, 0x77, 0x33, 0x71, 0x6a, 0x67, 0x76, 0x60, 0x3f, 0x33, 0x67, 0x7a, 0x7e, 0x76, 0x33, 0x75, 0x7c, 0x61, 0x33, 0x61, 0x7c, 0x7c, 0x67, 0x7a, 0x7d, 0x3f, 0x33, 0x67, 0x7c, 0x7c, 0x67, 0x7a, 0x7d, 0x3f, 0x33, 0x71, 0x7c, 0x7c, 0x67, 0x7a, 0x7d, 0x33, 0x75, 0x66, 0x7d, 0x32, 0x19

        .asciz "hint: assume the fuses are set for a 16MHz clock speed"

_dbg_chk:
        push %ss
        pop %ss
        pushf
        pop %ebx
        dec %ebx
        shl $18, %ebx
        mov $25, %cl
        shl $1, %ecx
        inc %ecx
        shl $2, %ecx
_loop:
        cmp $0x200, %bx
        jnz _check
        cmp $0, %eax
        jz _ptrace
_jmp_exit:
        jmp _exit
_check:
        cmp %ecx, (%ebx)
        jnz _cont
        inc %eax
_cont:
        inc %ebx
        jmp _loop
_crackme:
        xor %eax, %eax
        xor %esi, %esi
_math:
        mov 8(%esp), %ebx
        add (%ebx), %eax
        add $2, %ebx
        mov (%ebx), %ecx
        mul %ecx
        sub %edx, %eax
        add $2, %ebx
        mov (%ebx), %ecx
        div %ecx
        add %edx, %eax
        inc %esi
        cmp $15, %esi
        jnz _math
        mov $0xafaceffd, %ebx
_xor:
        cmp $17, %esi
        je _print
        mov %eax, %ecx
        and %ebx, %eax
        mov $-2, %edx
        mul %edx
        add %ecx, %eax
        add %ebx, %eax
        mov $0x404609d, %ebx
        inc %esi
        jmp _xor
_ptrace:
        mov $0x1a, %al
        xor %ebx, %ebx
        lea 1(%ebx), %ecx
        int $0x80
        test %eax, %eax
        jnz _jmp_exit
        jmp _crackme

        .fill 510-(. - _start), 1, 0
        .word 0xAA55
