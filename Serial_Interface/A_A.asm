DATA SEGMENT

DATA ENDS
STACK SEGMENT PARA STACK
        DW 128H DUP(0)
STACK ENDS

CODE SEGMENT
        ASSUME DS:DATA, CS:CODE, SS:STACK
START:  MOV AX, DATA
        MOV DS, AX

        MOV DX, 0E4B9H
	MOV AL, 0
	OUT DX, AL
	OUT DX, AL
	OUT DX, AL 
	MOV AL, 40H
	OUT DX, AL 
	MOV AL, 4EH 
	OUT DX, AL
	MOV AL, 27H
	OUT DX, AL

        MOV AL,  1EH                        ;N = 52
        MOV DX, 0E483H
        OUT DX, AL
        MOV DX, 0E480H
        MOV AL, 52
        OUT DX, AL

NNN:    MOV AH, 1
        INT 21H
        CMP AL, 1BH
        JE OVER

        MOV BL, AL                  ;COPY 
NEXT:   MOV DX, 0E4B9H
        IN AL, DX
        TEST AL, 01H
        JZ NEXT
        MOV AL, BL
        MOV DX, 0E4B8H
        OUT DX, AL

L1:     MOV DX, 0E4B9H
        IN AL, DX
        TEST AL, 02H
        JZ L1
        MOV DX, 0E4B8H
        IN AL, DX
        MOV DL, AL
        MOV AH, 0EH
        INT 10H
        JMP NNN

OVER:   MOV AH, 4CH
        INT 21H

CODE ENDS
END START
