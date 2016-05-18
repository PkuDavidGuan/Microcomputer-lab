DATA SEGMENT
        ADDER DB 10H, 11H, 12H, 13H, 14H, 15H
        N DB 6H
        SUM DB 0H
DATA ENDS

CODE SEGMENT
        ASSUME CS:CODE, DS:DATA
START:  MOV AX, DATA
        MOV DS, AX
        MOV BX, 0H
        MOV AL, 0H
re_in:  ADD AL, ADDER[BX]
        INC BX
        CMP BX, N
        JL  re_in
        MOV SUM, AL
        MOV AX, 4C00H
        INT 21H
CODE ENDS
END START

