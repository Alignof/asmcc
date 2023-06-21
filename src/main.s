.intel_syntax noprefix
.data
.STRING_INVALID_ARGUMENT: .string "invalid arguments\n"
.STRING_EPILOGUE: .string ".intel_syntax noprefix\n.globl main\n"
.STRING_LABEL_MAIN: .string "main:\n"
.STRING_MOV_ARGV1_TO_RAX: .string "\tmov rax, "
.STRING_LINEBREAK: .string "\n"
.STRING_RET: .string "\tret\n"
.text
.globl main

main:
    # prologue
    push rbp
    mov rbp, rsp
    sub rsp, 0x10   # align16byte(int(4byte) + char*(8byte)) = 0x10(16byte)

    # get argc/argv from arguments
    mov DWORD PTR [rbp - 0x4], edi  # int argc
    mov QWORD PTR [rbp - 0x10], rsi # char **argv

    # if (argc != 2) {
        cmp edi, 2
        je .ARGC_IS_2

        # write(2, "invalid arguments\n", 18);
        mov rdx, 18 # len("invalid arguments\n")
        lea rsi, .STRING_INVALID_ARGUMENT[rip] # string 
        mov rdi, 2  # stderr
        mov rax, 1  # write syscall
        syscall

        # return 1;
        mov rax, 1
        mov rsp, rbp
        pop rbp
        ret

    .ARGC_IS_2:
    #}

    # write(1, ".intel_syntax noprefix\n.globl main\n", 35);
    mov rdx, 35 # len(".intel_syntax noprefix\n.globl main\n")
    lea rsi, .STRING_EPILOGUE[rip] # string 
    mov rdi, 1  # stdout
    mov rax, 1  # write syscall
    syscall

    # write(1, "main:\n", 6);
    mov rdx, 6  # len("main:\n")
    lea rsi, .STRING_LABEL_MAIN[rip] # string 
    mov rdi, 1  # stdout
    mov rax, 1  # write syscall
    syscall

    # write(1, "\tmov rax, ", 11);
    mov rdx, 11 # len("\tmov rax, ")
    lea rsi, .STRING_MOV_ARGV1_TO_RAX[rip] # string 
    mov rdi, 1  # stdout
    mov rax, 1  # write syscall
    syscall

    # write(1, argv[1], 2);
    mov rsi, [rbp - 0x10] # char **argv 
    mov rsi, [rsi] # char *argv
    add rsi, 8  # argv + 1
    # seek null charactor and count length
    mov rdx, rsi
.BEGIN_COUNT:
    mov al, [rdx]
    cmp al, 0
    je .END_COUNT
    add rdx, 1
    jmp .BEGIN_COUNT
.END_COUNT:    

    sub rdx, rsi    # len
    mov rdi, 1  # stdout
    mov rax, 1  # write syscall
    syscall

    # write(1, "\n", 1);
    mov rdx, 1 # len("\n")
    lea rsi, .STRING_LINEBREAK[rip] # string 
    mov rdi, 1  # stdout
    mov rax, 1  # write syscall
    syscall

    # write(1, "\tret\n", 5);
    mov rdx, 5 # len("\tret\n")
    lea rsi, .STRING_RET[rip] # string 
    mov rdi, 1  # stdout
    mov rax, 1  # write syscall
    syscall

    # return 0;
    mov rax, 0

    # epilogue
    mov rsp, rbp
    pop rbp
    ret
