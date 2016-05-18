DATA SEGMENT
MYDATA  DB 080H,096H,0AEH,0C5H,0D8H,0E9H,0F5H,0FDH
        DB 0FFH,0FDH,0F5H,0E9H,0D8H,0C5H,0AEH,096H
        DB 080H,066H,04EH,038H,025H,015H,009H,004H
        DB 000H,004H,009H,015H,025H,038H,04EH,066H
DATA ENDS
STACK SEGMENT PARA STACK
        DB 255 DUP(?)
STACK ENDS
CODE SEGMENT
        ASSUME DS:DATA, CS:CODE, SS:STACK
START:  MOV AX, DATA
        MOV DS, AX

        MOV CX, 0FFH

CONVERT:
        MOV DX, 0E498H
        MOV AL, 1
        OUT DX, AL
        CALL DELAY
        IN AL, DX
        MOV BL, AL
        SHR AL, 1
        SHR AL, 1
        SHR AL, 1
        SHR AL, 1
        CALL DISP
        MOV AL, BL
        CALL DISP
        CALL NEWLINE
        MOV AH, 1
        INT 16H
        JNZ OVER
        JMP CONVERT

OVER:   MOV AH, 4CH
        INT 21H

DISP PROC NEAR
        PUSH DX
        AND AL, 0FH
        MOV DL, AL
        CMP DL, 9
        JLE NUM
        ADD DL, 7
NUM:    ADD DL, 30H
        MOV AH, 02H
        INT 21H
        POP DX
        RET
DISP ENDP

NEWLINE PROC NEAR
        PUSH DX
        MOV AH, 02H
        MOV DL, 0DH
        INT 21H
        MOV DL, 0AH
        INT 21H
        POP DX
        RET
NEWLINE ENDP

DELAY PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        MOV CX, 01111B
        MOV DX, 0
        MOV AH, 86H
        INT 15H
        POP DX
        POP CX
        POP BX
        POP AX
        RET
DELAY ENDP

CODE ENDS
END START
