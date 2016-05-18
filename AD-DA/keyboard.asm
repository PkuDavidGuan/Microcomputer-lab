DATA SEGMENT
MYDATA  DB 080H,096H,0AEH,0C5H,0D8H,0E9H,0F5H,0FDH
        DB 0FFH,0FDH,0F5H,0E9H,0D8H,0C5H,0AEH,096H
        DB 080H,066H,04EH,038H,025H,015H,009H,004H
        DB 000H,004H,009H,015H,025H,038H,04EH,066H
COUNTER DB 0H
TMP     DB 0H
LLOW    DB 0H
DATA ENDS
STACK SEGMENT PARA STACK
        DB 255 DUP(?)
STACK ENDS
CODE SEGMENT
        ASSUME DS:DATA, CS:CODE, SS:STACK
START:  MOV AX, DATA
        MOV DS, AX

        MOV DX, 0E48BH
        MOV AL, 89H
        OUT DX, AL
INPUT:  MOV AH, 01H
        INT 21H
        CMP AL, 'A'
        JE A
        CMP AL, 'B'
        JE B
        CMP AL, 'C'
        JE C
        CMP AL, 'D'
        JE D
        CMP AL, 'E'
        JE E
        CMP AL, 'F'
        JE F
        CMP AL, 'G'
        JE G
        JMP OVER
A:      MOV LLOW, 71
        JMP BEEP
B:      MOV LLOW, 63
        JMP BEEP
C:      MOV LLOW, 119
        JMP BEEP
D:      MOV LLOW, 106
        JMP BEEP
E:      MOV LLOW, 95
        JMP BEEP
F:      MOV LLOW, 89
        JMP BEEP
G:      MOV LLOW, 80
BEEP:   
        MOV COUNTER, 0
L2:     LEA SI, MYDATA
        MOV TMP, 0

        MOV AL, 10H
        MOV DX, 0E483H
        OUT DX, AL
        MOV DX, 0E480H
        MOV AL, LLOW
        OUT DX, AL
        
L1:     MOV DX, 0E48AH         ;READ THE CONTENT FROM PORT C
        IN AL, DX
        CMP AL, 0
        JE L1
        MOV DX, 0E490H
        MOV AL, [SI]
        OUT DX, AL
        INC SI

        MOV AL, 10H
        MOV DX, 0E483H
        OUT DX, AL
        MOV DX, 0E480H
        MOV AL, LLOW
        OUT DX, AL

        ADD TMP, 1
        CMP TMP, 32
        JL L1

        ADD COUNTER, 1
        CMP COUNTER, 100
        JL L2

        MOV AH, 1
        INT 16H
        JZ BEEP
        JMP INPUT
OVER:   MOV AH, 4CH
        INT 21H
       
CODE ENDS
END START
