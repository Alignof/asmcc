.intel_syntax noprefix
.data
.text
.globl printf

# rax -> number of args
# rdi(1st) -> format string
# rsi(2nd) -> arg1
# rdx(3rd) -> arg2
# rcx(4th) -> arg3...
printf:
    # prologue
    push rbp
    mov rbp, rsp

    # seek null charactor and count length
    mov rdx, rdi # seek(rdx) = rdi(1st arg)
    mov rcx, rdx # head(rcx) = seek(rdx)
    # while (*seek != 0) {
    .BEGIN_SEEK_NULL:
        mov al, BYTE PTR [rdx]
        cmp al, 0
        je .END_SEEK_NULL
        ## if (seek != '%') {
        #    cmp al, 0x25 # '%' == 0x25
        #    je .SEEK_IS_PERCENT

        #    # write(1, seek, head - seek);
        #    # evaculate
        #    push rdx # seek
        #    lea rsi, rdx # 2nd: string 
        #    sub rdx, rcx # 3rd: seek - head
        #    mov rdi, 1  # stdout
        #    mov rax, 1  # syscall num: write syscall
        #    syscall
        #    # restore
        #    pop rdx
        #    #=====end func=====

        #    # seek++
        #    add rdx, 1

        #    # switch (*seek) {
        #        mov al, BYTE PTR [rdx]
        #        cmp al, 'd'
        #        je .SEEK_IS_d
        #    .SEEK_IS_d
        #        # write(2, num, len(num));
        #        lea rsi, rdx # 2nd: string 
        #        sub rdx, rcx # 3rd: len(num)
        #        mov rdi, 1  # stdout
        #        mov rax, 1  # syscall num: write syscall
        #        syscall
        #        #=====end func=====
        #        j .END_SWITCH_SEEK
        #    .END_SWITCH_SEEK
        #    #}
        #.SEEK_IS_PERCENT:
        ##}
        add rdx, 1 # seek++;
        jmp .BEGIN_SEEK_NULL
    .END_SEEK_NULL:    
    #}

    # write(1, seek, head - seek);
    mov rsi, rcx # 2nd: string 
    sub rdx, rcx # 3rd: seek - head
    mov rdi, 1  # stdout
    mov rax, 1  # syscall num: write syscall
    syscall
    #=====end func=====

    # epilogue
    mov rsp, rbp
    pop rbp
    ret


#while (*seek != 0) {
#  if (*seek == '%') {
#      write(1, head, seek - head);
#      seek++;
#      if (seek == 'd') {
#          char *num = num_to_string(arg_n);
#          write(1, num, len(num));
#      }
#      head = seek + 1;
#  }
#  seek++;
#}
#write(1, head, seek - head);
