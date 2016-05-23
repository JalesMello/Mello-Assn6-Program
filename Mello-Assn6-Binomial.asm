;-----------------------------------------------------------
; Author: Jales H. Mello
; Course: CS370
; Last Update: 03/06/16
; Description: This part of the program contains the Binomial
;              Procedure. It calculates the Binomial Coefficient
;              of two numbers and returns it via the EAX register.
;-----------------------------------------------------------

TITLE Mello-Ass6-Binomial          (Mello-Ass6-Binomial.asm)

INCLUDE Irvine32.inc
INCLUDE Macros.inc 

.code
;-----------------------------------------------------------
Binomial PROC
;
; Description: Calculates the Binomial Coefficient of two 
;              numbers recursivley and returns it via the 
;              EAX register.
; Receives:    Two numerical parameters used to calculate 
;              the Binomial Coefficient.
; Returns:     The Binomial Coefficient via the EAX register.
;-----------------------------------------------------------
; Recursive Formula:
; Binomial (int n, int d)
; - if (d == 0 || d ==n) -> return 1
; - else -> return Binomial (n-1, d-1) + (n-1, d)

     push ebp                      ; Save the base pointer for the stack.
     mov  ebp, esp                 ; Set the EBP register to the beginning of the current stack frame.

     mov  ebx, [ebp + 12]          ; Get the n value for the formula
     mov  edx, [ebp + 8]           ; Get the d value for the formula

; 1st - check the base case: if (d == 0 || d ==n)
     cmp  edx, 0                   ; Check if (d == 0)
     jz   CalcCoefficient          ; Jump to CalcCoefficient if 0
     cmp  edx, ebx                 ; Check if (d == n)
     jz   CalcCoefficient          ; Jump to CalcCoefficient if (d == n)

; 2nd - recursive call: (n-1, d)
     dec  ebx                      ; Decrement the EBX register
     push ebx                      ; Push the EBX onto stack
     push edx                      ; Push the EDX onto stack
     call Binomial                 ; Recursive call

; Clear portion of stack
     pop  edx
     pop  ebx

     mov  ebx, [ebp + 12]          ; Get the n value for the formula
     mov  edx, [ebp + 8]           ; Get the d value for the formula

; 3rd - recursive call: (n-1, d-1)
     dec  ebx                      ; Decrement the EBX register
     dec  edx                      ; Decrement the EDX register
     push ebx                      ; Push the EBX onto stack
     push edx                      ; PUsh the EDX onto stack
     call Binomial                 ; Recursive call

; Clear portion of stack
     pop  edx                      
     pop  ebx
     pop  ebp
     jmp  Done                     ; Return to calling procedure

; 4th - Calculate the Coefficient:
CalcCoefficient:
     inc  eax                      ; Increment the count / EAX register
     pop  ebp                      ; Pop the EBP register

Done:

     ret
Binomial ENDP
END