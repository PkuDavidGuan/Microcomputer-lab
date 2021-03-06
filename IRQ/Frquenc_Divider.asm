DATA SEGMENT
    
DATA ENDS

STACK SEGMENT
    DW 128H DUP(0)
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
START:
    MOV AX,DATA
    MOV DS,AX
    
    MOV AL,  37H                        ;2M -> 1K
    MOV DX, 0E483H
    OUT DX, AL
    MOV DX, 0E480H
    MOV AL, 00H
    OUT DX, AL
    MOV AL, 20H
    OUT DX, AL
    
    MOV AL, 77H                         ;1K -> 1
    MOV DX, 0E483H
    OUT DX, AL
    MOV DX, 0E481H
    MOV AL, 00H
    OUT DX, AL
    MOV AL, 10H
    OUT DX, AL
    
NNN:
	MOV AH, 1
	INT 16H
    JZ NNN
    
    MOV AH,4CH
    INT 21H
CODE ENDS
    END START

