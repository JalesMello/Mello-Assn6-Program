;-----------------------------------------------------------
; Author: Jales H. Mello
; Course: CS370
; Last Update: 03/06/16
; Description: This Program gets a number from 1 - 10 from 
;              the user and displays Pascal's Triangle for
;              the given number using a recursive formula
;              for calculating Binomial Coefficients. The 
;              user can continue selecting numbers or enter
;              0 to exit the program.
;-----------------------------------------------------------

TITLE Mello-Ass6-Program           (Mello-Ass6-Program.asm)

INCLUDE Irvine32.inc
INCLUDE Macros.inc                 ; for memory dump

; Procedure Prototypes:
ReadInteger PROTO
Binomial PROTO
WriteInteger PROTO
DigitToAscii PROTO

.data
IntPrompt BYTE "Enter an integer (1 thru 10, or 0 to exit): ", 0           ; Prompt to receive an integer from the user.
ErrPrompt BYTE "Error. You entered an inavlid value. Try Again.",13,10,0   ; Prompt when user enters an invalid value.
userNum DWORD ?                    ; The valid, user entered number used to calculate the Binomial Coefficient.
space BYTE " ",0                   ; A space between Binomial Coefficients

.code
main PROC
     
; 1st - Prompt the User for an integer:
GetInt:                            ; Label to repeat the GetInt section if user entered an invalid #.
     mov  eax, 0d                  ; Clear the EAX register.
     mov  edx, OFFSET IntPrompt    ; Set the Integer Prompt.
     call WriteString              ; Display the Integer Prompt.
     call ReadInteger              ; Call the ReadInteger Proc to get the integer.

; 2nd - Check if user entered a 0 to exit:
     cmp  eax, 0                   ; Check if 0.
     jz   Done                     ; Exit the program if 0.

; 3rd - Check if the integer entered was within the range:
     cmp  eax, 11d                 ; Check if the integer came back invalid.
     jnz  Continue                 ; Jump to Continue if the integer is valid. Else....
     mov  edx, OFFSET ErrPrompt    ; Set the Error Prompt.
     call WriteString              ; Display the Error Prompt.
     jmp  GetInt                   ; Jump to GetInt to get another integer.
Continue:                          ; Continue the program if valid.

; 4th - Begin calculating the coefficients and displaying Pascal's Triangle
     mov  userNum, eax             ; Copy the EAX register to the userNum variable to be used in the calculation.
     mov  ecx, userNum             ; Set the loop count to the number the user chose.
     mov  ebx, 1                   ; Set the EBX register to the minimum value and count up until reached user's selected number.

OuterLoop:
     push ecx                      ; Save the ECX register prior to setting the spaces
     mov  edx, OFFSET space        ; Set the EDX register to the space OFFSET.

SetSpaces:
     call WriteString              ; Add spaces to console.
     loop SetSpaces                ; Loop to SetSpaces.
     mov  edx, 0                   ; Clear the EDX register.
     pop  ecx                      ; Restore the ECX register.
; End SetSpaces
    
; Continue with OuterLoop
     push ecx                      ; Save the ECX register to the stack (the count).
     mov  edx, 0                   ; Zero out the EDX register prior to each InnerLoop.
     mov  ecx, ebx                 ; Set the count to the current row prior to the InnerLoop.
     dec  ebx                      ; Decrement the EBX for Pascal's Triangle.

InnerLoop:
     ; Call the Binomial Procedure
     push ebx                      ; n = EBX register.
     push edx                      ; d = EDX register.
     mov  eax, 0                   ; Zero out EAX register.
     call Binomial                 ; Call the Binomial Procedure
     pop  edx                      ; Pop back the EDX register.
     pop  ebx                      ; Pop back the EBX register.

; Write the Binomial Coefficient to the console.
     pushad                        ; Save all the registers before calling WriteInteger
     mov  ebx, 10d                 ; Set the EBX register to the base case.
     call WriteInteger             ; Call WriteInteger to display the Coefficient to the console.
     popad                         ; Pop back all the registers.
     
; Add spaces between each number.
     push edx                      ; Save the EDX register prior to displaying a space.
     mov  edx, OFFSET space        ; Move the space OFFSET to the EDX register.
     call WriteString              ; Write a space to the console.
     pop  edx                      ; Pop back the EDX register.

     inc  edx                      ; Increment the EDX register to continue counting up the row of Pascal's Triangle.
     loop InnerLoop                ; Loop back to InnerLoop until the current row of Pascal's Triangle is finished.
; End the InnerLoop

; return to OuterLoop
     call Crlf                     ; Start a new row of Pascal's Triangle
     inc  ebx                      ; Increment the EBX register to continue counting down to the next level of Pascal's Triangle.
     inc  ebx                      ; Increment the EBX register again to maintain proper counting.
     pop  ecx                      ; Pop back the OuterLoop count to the ECX register.
     loop OuterLoop                ; Loop back to Outerlooop until Pascal's Triangle is finished for the user chosen value.

; 5th - Repeat the process until the user decides to exit the program.
     call Crlf                     ; Start a newline.
     jmp  GetInt                   ; Jump to GetInt to repeat the process.

Done:                              ; Label to Exit the Program.
     call Crlf                     ; Start a newline.

     exit
main ENDP
END main