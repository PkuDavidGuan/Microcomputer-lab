STACK SEGMENT PARA STACK
        DW 128H DUP(0)
STACK ENDS

DATA SEGMENT
        DEVICE DB 0DH, 0AH, 'DEVICE ID IS: $'
        VENDOR DB 'VENDOR ID IS: $'
DATA ENDS

CODE SEGMENT
        ASSUME CS:CODE, SS:STACK, DS:DATA
START:  MOV AX, DATA
        MOV DS, AX
        MOV BX, 0
LOOP1:  MOV DI, 0
        MOV AX, 0B109H
        INT 1AH
        CMP CX, 0FFFFH
        JE OVER

        MOV DX, OFFSET DEVICE         ;Output the device id and vendor id
        MOV AH, 9
        INT 21H
        MOV AX, 0B109H
        MOV DI, 0H
        INT 1AH
        MOV AX, CX
        CALL DISP
        MOV DL, ' '
        MOV AH, 2
        INT 21H
        MOV DX, OFFSET VENDOR
        MOV AH, 9
        INT 21H
        MOV AX, 0B109H
        MOV DI, 2H
        INT 1AH
        MOV AX, CX
        CALL DISP

        MOV AX, BX
        AND AX, 7H
        CMP AX, 0
        JNE OVER
        MOV AX, 0B109H      ;Find out whether the device is single-funtion
        MOV DI, 0EH
        INT 1AH
        CMP CX, 0
        JNE OVER
        ADD BX, 7H

OVER:   INC BX
        CMP BX, 08FFH
        JLE LOOP1
        MOV AH, 4CH
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
