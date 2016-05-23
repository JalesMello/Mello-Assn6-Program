;-----------------------------------------------------------
; Author: Jales H. Mello
; Course: CS370
; Last Update: 03/06/16
; Description: This part of the program contains the necessary
;              IO procedures from Assn5 for this program.
;-----------------------------------------------------------

TITLE Mello-Ass6-IntegerIO         (Mello-Ass6-IntegerIO.asm)

INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data
digits BYTE '0123456789ABCDEF'     ; list of ASCII characters used for numeric conversion

.code

;-----------------------------------------------------------
ReadInteger PROC
;
; Description: Reads an integer from the user and returns it in EAX.
; Receives:    None.
; Returns:     The user integer (or 11, if the integer was 
;              outside the reange) in the EAX register.
; Note:        I removed all of the unnecessary code from the ReadInteger
;              procedure because it wasn't being used. Only the first half
;              of the procedure was relevant for this program.
;-----------------------------------------------------------

     call ReadInt                  ; get integer
     cmp  eax, 0d                  ; check if value is 0
     jz   Done                     ; exit program if 0
     cmp  eax, 1                   ; check if less than 1
     jl   Error                    ; jump to Error if less than 1
     cmp  eax, 10                  ; check if greater than 10
     jg   Error                    ; jump to Error if greater than 10
     jmp  Done                     ; in range, jump to Done and return

Error:
     mov  eax, 11d                 ; move 11 to EAX to reprompt in main

Done:
     ret
ReadInteger ENDP

;-----------------------------------------------------------
WriteInteger PROC
;
; Description: Converts a decimal integer into a base equivalent that is passed in and displays it to the screen
; Receives:    The decimal value in the EAX register
;              The base value in the EBX register
; Returns:     Nothing
;-----------------------------------------------------------
     mov  ecx, 0              ; set count to 0

; Begin calculating single digits by dividing and pushing the remainders to the stack
NextDigit:
     mov  edx, 0d             ; 0 out the remainder each divide
     div  ebx                 ; divide the decimal value by the base
     push edx                 ; push the remainder onto the stack
     inc  ecx                 ; increment the count
     cmp  eax, 0d             ; check if the decimal value is 0
     jne  NextDigit           ; if not 0, loop to next number in decimal value

; Pop numbers off stack and write them to the console for the user
OutDigit:     
     pop  eax                 ; pop number off stack to write
     cmp  eax, 10d            ; Check if popped number is over 10d (bascially checking if it should be displayed as A-F)
     jae  Hex                 ; jump to Hex if it is 10d or over
     or   al, 00110000b       ; add 0011 to get the ASCII character
     jmp  Continue            ; continue displaying integers

Hex:
     call DigitToAscii        ; convert the digit to an ASCII character

Continue:
     call WriteChar           ; write it to the console
     loop OutDigit            ; loop until all numbers are written to the console

     ret
WriteInteger ENDP

;-----------------------------------------------------------
DigitToAscii PROC USES esi
;
; Description: Converts a decimal value to its ASCII character equivalent
; Receives:    A decimal integer in the AL register
; Returns:     The decimal's ASCII character value in the EAX register
;-----------------------------------------------------------
     cmp  al, 0d              ; check if decimal value is less than 0
     jl   NotValid            ; jump to NotValid if less than 0
     cmp  al, 15d             ; check if decimal value is above 15
     ja   NotValid            ; jump to NotValid if above 15

; Value is valid, get ASCII character
   movzx  esi, al             ; copy the decimal value to the ESI register
   movzx  eax, digits[esi]    ; copy the ASCII character to the EAX register
     jmp  Finish              ; return to calling procedure

NotValid:
     mov  eax, -1d            ; copy -1 to the EAX register indicating that the decimal value was invalid

Finish:

     ret                      ; ASCII Character or -1 is in the EAX Register
DigitToAscii ENDP

END