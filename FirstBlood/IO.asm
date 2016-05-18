DATA SEGMENT
        ADDER DB 0H
        SUM DB 0H
DATA ENDS
STACK SEGMENT PARA STACK
        DW 128H DUP(0)
STACK ENDS

CODE SEGMENT
        ASSUME CS:CODE, DS:DATA, SS:STACK
START:  MOV AX, DATA
        MOV DS, AX
        CALL IN_NUM
        MOV AL, ADDER           ;AL save the first adder
        MOV ADDER, 0H           ;clear the adder
        CALL IN_NUM
        ADD AL, ADDER
        DAA                     ;transfer the data to BCD
        MOV SUM, AL
        JNC NOT_OF
        MOV DL, '1'
        MOV AH, 02H
        INT 21H
NOT_OF: MOV AL, SUM
        CALL DISP
        MOV CL, 4
        SHL AL, CL
        CALL DISP
        MOV AX, 4C00H
        INT 21H

IN_NUM PROC NEAR
        PUSH AX
        PUSH CX
RE_IN:  MOV AH, 01H
        INT 21H
        CMP AL, 0DH
        JZ EX_IN
        SUB AL, '0'
        JL RE_IN
        CMP AL, 9
        JG RE_IN
        MOV AH, ADDER
        MOV CL, 4
        SHL AH, CL
        ADD AH, AL
        MOV ADDER, AH
        JMP RE_IN
EX_IN:  MOV DL, 0DH
        MOV AH, 02H
        INT 21H
        MOV DL, 0AH
        MOV AH, 02H
        INT 21H
		POP CX
        POP AX
        RET
IN_NUM ENDP

DISP PROC NEAR
        PUSH DX
        PUSH CX
        PUSH AX
        MOV CL, 4
        SHR AL, CL
        ADD AL, '0'
        MOV DL, AL
        MOV AH, 02H
        INT 21H
        POP AX
        POP CX
        POP DX
        RET
DISP ENDP

CODE ENDS
END START

