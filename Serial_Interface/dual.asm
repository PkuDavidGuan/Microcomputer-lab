DATA SEGMENT
        STRTMP DB 100H DUP(0)
        LL  DB 0H
        MES DB 0H
        FLAG DB 0H
        COUNTER DB 0H
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

BEGIN:
        MOV AH, 02H
        MOV DL, 0DH
        INT 21H
        MOV DL, 0AH
        INT 21H
        LEA SI, STRTMP
        MOV LL, 0
        MOV FLAG, 0
        MOV COUNTER, 0
NNN:    
        MOV AH, 1
        INT 21H
        CMP AL, 1BH
        JE JUMP
        CMP AL, ' '
        JE SEND

        MOV [SI], AL
        XOR AX, AX
        MOV AL, LL
        INC AL
        DAA
        MOV LL, AL
        INC SI
        JMP NNN
JUMP:   JMP OVER
SEND:   XOR CX, CX
        LEA SI, STRTMP
IN_SEND:
        MOV DX, 0E4B9H
        IN AL, DX
        TEST AL, 01H
        JZ IN_SEND

        CMP FLAG, 2
        JL HEAD

        MOV DX, 0E4B8H
        MOV AL, [SI]
        OUT DX, AL
        INC SI
        XOR AX, AX
        MOV AL, COUNTER
        INC AL
        DAA
        MOV COUNTER, AL
        JMP NEXT
LONGJUMP:
        JMP BEGIN
HEAD:
        CMP FLAG, 1
        JE LB
        MOV AL, LL
        AND AL, 0F0H
        SHR AL, 1
        SHR AL, 1
        SHR AL, 1
        SHR AL, 1
        JMP SAME
LB:     MOV AL, LL
        AND AL, 0FH
SAME:   ADD AL, '0'
        MOV DX, 0E4B8H
        OUT DX, AL
        ADD FLAG, 1
NEXT:
        MOV BH, 1
L1:     
        CMP BH, 1
        JE L1

        MOV AL, MES
        MOV AH, 0EH
        INT 10H
        MOV CL, LL
        CMP COUNTER, CL
        JE LONGJUMP
        JMP IN_SEND     

OVER:   MOV AH, 4CH
        INT 21H




IRQ PROC FAR
        PUSH AX
        PUSH DX
        MOV DX, 0E4B8H
        IN AL, DX
        MOV MES, AL
        MOV BH, 0
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
