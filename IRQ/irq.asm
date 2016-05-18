DATA SEGMENT
    MESS DB 'THIS IS AN IRQ INTERRUPT!', 0AH, 0DH, '$'
DATA ENDS

STACK SEGMENT
    DW 128H DUP(0)
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
START:
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
    MOV CX, 10
    STI
    
NEXT:
	MOV AH, 1
	INT 16H
	JNZ OVER
	MOV BH, 1
LL: CMP BH, 0
	JNE NEXT
	CALL DISPMSG
	LOOP NEXT
	
	IN AL, 21H
	OR AL, 01000000B
	OUT 21H, AL
	
	MOV DX, 0EC4CH
	MOV AL, 42H
	OUT DX, AL
	STI
	
OVER:
	MOV AH, 4CH
	INT 21H
	
DISPMSG PROC NEAR
	MOV DX, OFFSET MESS
	MOV AH, 09H
	INT 21H
DISPMSG ENDP

IRQ PROC FAR
	PUSH AX
	PUSH DX
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

CODE ENDS
    END START

