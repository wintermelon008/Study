#include <iostream>
#include <unistd.h>
#include <sys/user.h>
#include <sys/wait.h>
#include <sys/ptrace.h>


int main(int argc, char **argv){
    if (argc <= 1) {
        std::cout << "Strace failed: Insufficient arguments.\n";
        exit(0);
    }

    pid_t pid = fork();
    switch (pid) {
        case -1: {
            std::cout << "Strace failed: Make thread error.\n";
            exit(0);
        }
        case 0:  {
            // 子进程
            ptrace(PTRACE_TRACEME, 0, 0, 0);           
            execvp(argv[1], argv + 1);
            std::cout << "Strace failed: Execvp error.\n";
            exit(0);
        }
    }
    // 父进程
    waitpid(pid, 0, 0); 
    ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_EXITKILL);

    while (true){
        ptrace(PTRACE_SYSCALL, pid, 0, 0);
        waitpid(pid, 0, 0);

        
        struct user_regs_struct regs;
        ptrace(PTRACE_GETREGS, pid, 0, &regs);
        long syscall = regs.orig_rax;

        fprintf(stderr, "%ld(%ld, %ld, %ld, %ld, %ld, %ld)\n",
                syscall,
                (long)regs.rdi, (long)regs.rsi, (long)regs.rdx,
                (long)regs.r10, (long)regs.r8,  (long)regs.r9);

        ptrace(PTRACE_SYSCALL, pid, 0, 0);
        if (waitpid(pid, 0, 0) == -1)
            exit(0);
    }
}