STACK SEGMENT PARA STACK
        DW 128H DUP(0)
STACK ENDS

DATA SEGMENT
        NOFOUND DB 'NOT FOUND', 0DH, 0AH, '$'
        IO DB 0DH, 0AH, 'IO ADDRESS IS: $'
        IPCI DB 0DH, 0AH, 'PCI9052 ADDRESS IS: $'
DATA ENDS

CODE SEGMENT
        ASSUME CS:CODE, SS:STACK, DS:DATA
START:  MOV AX, DATA
        MOV DS, AX
        MOV AH, 0B1H
        MOV AL, 2
        MOV CX, 9050H
        MOV DX, 10B5H
        MOV SI, 0
        INT 1AH

        CMP AH, 0
        JZ GOT
        MOV DX, OFFSET NOFOUND
        MOV AH, 9
        INT 21H
        JMP GOUT

GOT:    MOV AX, BX
        CALL DISP
        MOV DL, 0DH
        MOV AH, 2
        INT 21H
        MOV DL, 0AH
        MOV AH, 2
        INT 21H
        MOV DI, 0

LOOP1:  MOV AX, 0B109H
        INT 1AH
        MOV AX, CX
        CALL DISP
        MOV DL, ' '
        MOV AH, 2
        INT 21H

        INC DI
        INC DI
        CMP DI, 40H
        JL LOOP1

        MOV DX, OFFSET IO
        MOV AH, 9
        INT 21H
        MOV AX, 0B109H
        MOV DI, 1CH
        INT 1AH
        AND CX, 0FFFEH
        MOV AX, CX
        CALL DISP
        MOV DX, OFFSET IPCI
        MOV AH, 9
        INT 21H
        MOV AX, 0B109H
        MOV DI, 10H
        INT 1AH
        AND CX, 0FFFEH
        MOV AX, CX
        CALL DISP

GOUT:   MOV AH, 4CH
        INT 21H

DISP PROC NEAR
        PUSH BX
        PUSH CX
        MOV BX, AX
        MOV CX, 4
LLOOP1: MOV AX, BX
        CALL DISP2
        PUSH CX
        MOV CL, 4
        SHL BX, CL
        POP CX
        LOOP LLOOP1
        POP CX
        POP BX
        RET
DISP ENDP

DISP2 PROC NEAR
        PUSH DX
        PUSH CX
        AND AH, 0F0H
        MOV CL, 4
        SHR AH, CL
        MOV DL, AH
        CMP DL, 9
        JLE NUM
        ADD DL, 7
NUM:    ADD DL, 30H
        MOV AH, 02H
        INT 21H
        POP CX
        POP DX
        RET
DISP2 ENDP
CODE ENDS
END START
