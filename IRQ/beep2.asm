DATA SEGMENT                       ;利用存储器变量记录时、分、秒
    HOUR DB 0H
    MIN DB 0H
    SEC DB 0H
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    
    MOV AL, 37H                     ;以下两段是设置分频器，得到1HZ信号,
    MOV DX, 0E483H                  ;IRQ和分频器输出信号相连，实现每秒中断一次.
    OUT DX, AL
    MOV DX, 0E480H
    MOV AL, 00H
    OUT DX, AL
    MOV AL, 20H
    OUT DX, AL
    
    MOV AL, 77H
    MOV DX, 0E483H
    OUT DX, AL
    MOV DX, 0E481H
    MOV AL, 00H
    OUT DX, AL
    MOV AL, 10H
    OUT DX, AL

    MOV AX,CS
    MOV DS,AX
    
    MOV DX, OFFSET IRQ              ;设置中断服务程序
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
    MOV CX, 7FFFH
    STI
    
NEXT:
	    MOV BH, 1
LL:     MOV AH, 1             ;键盘有按键按下便返回
        INT 16H
        JNZ OVER
        CMP BH, 0             ;是否检验到中断
        JNE LL

        MOV BL, 255           ;响铃时长
        CALL BEEP
	LOOP NEXT
	
OVER:
    IN AL, 21H
	OR AL, 01000000B
	OUT 21H, AL
	
	MOV DX, 0EC4CH
	MOV AL, 42H
	OUT DX, AL
	STI
	
	MOV AH, 4CH
	INT 21H

BEEP PROC NEAR              ;输出时间并且判断是否响铃
        PUSH DX
	PUSH CX
        PUSH BX
        PUSH AX

        ADD SEC, 1           ;秒加一
        CMP SEC, 60          ;60s进1min
        JL OUTPUT
        ADD MIN, 1
        MOV SEC, 0
        CMP MIN, 60          ;1min进1h
        JL RING
        MOV MIN, 0
        ADD HOUR, 1
RING:
        MOV AL, 10110110B
	OUT 43H, AL
	MOV AX, 1190
	OUT 42H, AL
	MOV AL, AH
	OUT 42H, AL
	
	IN AL, 61H
	MOV AH, AL
	OR AL, 03H
	OUT 61H, AL
	
	MOV CX, 0
L0:
	LOOP L0
	DEC BL
	JNZ L0
	
	MOV AL, AH
	OUT 61H, AL

OUTPUT:      
        MOV AL, HOUR       ;输出显示时、分、秒
        MOV CL, 4
        SHR AL, CL
        CALL DISP
        MOV AL, HOUR
        CALL DISP

        MOV DL, ' '
        MOV AH, 02H
	INT 21H

        MOV AL, MIN
        MOV CL, 4
        SHR AL, CL
        CALL DISP
        MOV AL, MIN
        CALL DISP

        MOV DL, ' '
        MOV AH, 02H
	INT 21H

        MOV AL, SEC
        MOV CL, 4
        SHR AL, CL
        CALL DISP
        MOV AL, SEC
        CALL DISP

        MOV DL, 0DH
        MOV AH, 02H
        INT 21H
        MOV DL, 0AH
        MOV AH, 02H
        INT 21H

        POP AX
        POP BX
	POP CX
        POP DX
	RET
BEEP ENDP

DISP PROC NEAR
	PUSH DX
	AND AL, 0FH
	MOV DL, AL
	CMP DL, 9
	JLE NUM
	ADD DL, 7
NUM:
	ADD DL, 30H
	MOV AH, 02H
	INT 21H
	
	POP DX
	RET
DISP ENDP


IRQ PROC FAR                   ;中断服务程序
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
