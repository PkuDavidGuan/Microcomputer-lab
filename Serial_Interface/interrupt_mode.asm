DATA SEGMENT
        STRTMP DB 100H DUP(0)
        LL  DB 0H
DATA ENDS
STACK SEGMENT PARA STACK
        DW 128H DUP(0)
STACK ENDS

CODE SEGMENT
        ASSUME DS:DATA, CS:CODE, SS:STACK
START:  MOV AX, DATA
        MOV DS, AX

        MOV DX, 0E4B9H                   ;initiate
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
                                            ;IRQ
        MOV AX,CS
        MOV DS,AX
    
        MOV DX, OFFSET IRQ
        MOV AX, 250EH
        INT 21H
        CLI
    
        MOV DX, 0EC4CH
        MOV AL, 43H
        OUT DX, AL
        INC DX
        MOV AL, 1DH
        OUT DX, AL
        IN AL, 21H
        AND AL, 10111111B
        OUT 21H, AL
    
        MOV AX, DATA
        MOV DS, AX
        STI

        LEA SI, STRTMP
NNN:    
        MOV AH, 7
        INT 21H
        CMP AL, 1BH
        JE OVER
        CMP AL, ' '
        JE SEND

        MOV [SI], AL
        ADD LL, 1
        INC SI
        JMP NNN

SEND:   XOR CX, CX
        LEA SI, STRTMP
        MOV CL, LL
IN_SEND:
        MOV DX, 0E4B9H
        IN AL, DX
        TEST AL, 01H
        JZ IN_SEND
        MOV DX, 0E4B8H
        MOV AL, [SI]
        OUT DX, AL
        INC SI
        DEC CX
        CMP CX, 0
        JE OVER
NEXT:
        MOV BH, 0
L1:     
        CMP BH, 0
        JE L1

        MOV AL, BH
        MOV AH, 0EH
        INT 10H
        JMP IN_SEND     

OVER:   MOV AH, 4CH
        INT 21H


IRQ PROC FAR
        PUSH AX
        PUSH DX
        MOV DX, 0E4B8H
        IN AL, DX
        MOV BH, AL
        MOV AL, 20H
        OUT 20H, AL
        MOV DX, 0EC4DH
        MOV AL, 1DH
        OUT DX, AL
        POP DX
        POP AX
        IRET
IRQ ENDP

CODE ENDS
END START
