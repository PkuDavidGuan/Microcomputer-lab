DATA SEGMENT
    LED DB 3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H
    	DB 7FH, 67H, 77H, 7CH, 39H, 5EH, 79H, 71H 
DATA ENDS
STACK SEGMENT
	DW 128H DUP(0)
STACK ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA, SS:STACK
START:
    MOV AX,DATA
    MOV DS,AX
    
    MOV DX, E48BH ;SHOULD CHANGE THE ADDRESS OF CONTROL PORT
    MOV AL, 90H
    OUT DX, AL
    
INOUT:
	MOV DX, E48AH ;SHOULD BE THE ADDRESS OF THE PORT A
	IN AL, DX
	
	XOR CX, CX
FUN:
	MOV AL, CL
	MOV BX, OFFSET LED
	XLAT
	MOV DX, E48BH; SHOULD BE THE ADDRESS OF PORT A
	OUT DX, AL
	
	PUSH CX       ;WAIT
	MOV AH, 86H
	MOV CX, 5
	MOV DX, 0
	INT 15H
	POP CX
	
	INC CX
	CMP CX, 0FH
	JLE FUN
	
	;PRINT AGAIN?
	XOR CX, CX
FUN2:
	MOV AL, CL
	MOV BX, OFFSET LED
	XLAT
	MOV DX, E48BH; SHOULD BE THE ADDRESS OF PORT A
	OUT DX, AL
	
	PUSH CX       ;WAIT
	MOV AH, 86H
	MOV CX, 5
	MOV DX, 0
	INT 15H
	POP CX
	
	INC CX
	CMP CX, 0FH
	JLE FUN2
	
	MOV AH, 1
	INT 16H
	JZ INOUT
    
    MOV AH,4CH
    INT 21H
CODE ENDS
    END START

