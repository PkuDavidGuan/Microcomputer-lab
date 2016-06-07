;-----------------------------画实心矩形宏--- ---------------------------------
DRAW MACRO START_X, START_Y, END_X, END_Y, COLOR
	LOCAL DRAW_NEXT
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	MOV AH, 0CH					;写像素点
	MOV AL, COLOR					;设置颜色
	MOV BH, 0					;选用页号0
	MOV CX, START_X					;列起始点
	MOV DX, START_Y					;行起始点
DRAW_NEXT:
	INT 10H						;画点
	INC CX						;画横线
	CMP CX, END_X					;比较行是否画完
	JNE DRAW_NEXT					;画另一行
	MOV CX, START_X					;另一行的起始点
	INC DX
	CMP DX, END_Y					;比较列是否画完
	JNE DRAW_NEXT					;未完继续画
	POP DX
	POP CX
	POP BX
	POP AX
ENDM

;-------------------------------- 画空心矩形宏---------------------------------
DRAWSQRE MACRO START_X, START_Y, END_X, END_Y, COLOR
	LOCAL ROW_UP, RANK_RIGHT, ROW_DOWN, RANK_LEFT
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	MOV AH, 0CH
	MOV AL, COLOR
	MOV BH, 0
	MOV CX, START_X					
	MOV DX, START_Y					
ROW_UP:						
	INT 10H
	INC CX
	CMP CX, END_X
	JNE ROW_UP
RANK_RIGHT:						
	INT 10H
	INC DX
	CMP DX, END_Y
	JNE RANK_RIGHT
	MOV CX, START_X
	MOV SI, END_X
	INC SI
ROW_DOWN:					
	INT 10H
	INC CX
	CMP CX, SI
	JNE ROW_DOWN
	MOV DX, START_Y
	MOV CX, START_X
RANK_LEFT:						
	INT 10H
	INC DX
	CMP DX, END_Y
	JNE RANK_LEFT
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
ENDM

;-------------------------------- 数据--------------------------------------
DATA SEGMENT
    TEXT1 DB '******  PLAY  ******', 0DH, 0AH, '$'	
	TEXT2 DB '**  Listen to a song, please press P  **', 0DH, 0AH,'$'
	TEXT3 DB '**  Exit, please press ESC  **', '$'
	TEXT4 DB 'WELCOME!^_^', '$'
    TEXT5 DB '**  Record your voice, press SPACE  **', '$'
	TEXT6 DB '**  MAY THE STRENGTH BE WITH YOU  **', 0DH, 0AH,'$'
	TEXT7 DB 'ENJOY YOURSELF!', '$'
	TEXT8 DB 'MADE BY : Guan Yushuo','$'
	TEXT9 DB '**  JUST DO NOTHING, PLEASE WAIT  **','$'
	TEXT10 DB '******  CLASSIC RECORDER  ******', '$'
	TEXT11 DB '1.You have to press SPACE to record', '$'	
	TEXT12 DB '2.WOW, VOICE! PRESS TO PLAY', '$'
	TEXT13 DB '3.Please press P to play', '$'

	MYDATA   DB 10000 DUP(0)                ;MYDATA、PKU1、PKU2、INDEX、LOOPTIMER、HEIGHT用于LED显示                                        
	pku1     db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 01h, 03h, 07h, 0Fh, 1Fh, 3Fh, 7Fh, 0FFH 
	pku2     db 00h, 01h, 03h, 07h, 0Fh, 01Fh,03Fh,07Fh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFH
	index    dw  00h
	looptimer db 00h
	HEIGHT   DB  00H
	FILENAME DB 'D:\STUDENT\TMP.TXT', 0    ;FILENAME、FILEDES、FILENUM用于文件操作
	FILEDES  DW 00H
	FILENUM  DW 00H


	MUS_FREQ  DW 330, 392, 262, 294, 330, 196, 262, 294, 330, 392, 294    ;频率
			  DW 330, 392, 262, 294, 330, 220, 294, 196, 294, 330, 262
			  DW 440, 392, 440, 262, 330, 220, 330, 392, 294
			  DW 330, 392, 262, 294, 330, 220, 294, 196, 294, 330, 262
			  DW -1
	MUS_TIME  DW 2 DUP(2500), 5000, 2 DUP(2500), 5000, 4 DUP(2500), 10000  ;时间
	          DW 2 DUP(2500), 5000, 2 DUP(2500), 5000, 4 DUP(2500), 10000
	          DW 4 DUP(5000), 4 DUP(2500), 10000
	          DW 2 DUP(2500), 5000, 2 DUP(2500), 5000, 4 DUP(2500), 10000
DATA ENDS

STACK SEGMENT PARA STACK
        DB 255 DUP(?)
STACK ENDS
;-----------------------------------主程序--------------------------------
CODE SEGMENT
	ASSUME DS:DATA, CS:CODE, SS:STACK
START:
	MOV AX, DATA
	MOV DS, AX			
    CALL INIT			;初始化
	MOV DH, 26
	MOV DL, 0
	MOV AH, 2			;放置光标位置
	INT 10H

INPUT2: 
    	MOV AH, 7      ;输入字符
    	INT 21H
    	CMP AL, 70H    ;70h or 50h
    	JNE CC1
        CALL SONG 
        JMP INPUT2
CC1:    CMP AL, ' '    ;空格进入录音程序
        JNE CC2
        JMP RCD
CC2:    CMP AL, 27     ;ESC退出
        JE OVER
        JMP INPUT2

RCD:    CALL DISP      ;录音界面绘制
INPUT:  
        MOV AH, 7
        INT 21H
        CMP AL, 20H    ;空格开始录音
        JNE INPUT
        CALL RECORDER  ;录音
        CALL WAVE      ;波形显示
INPUT3: MOV AH, 7
		INT 21H
        CMP AL, 50H              ;50 OR 70?
		JE  PY
		CMP AL, 27               ;esc退出
		JNE INPUT3
		CALL INIT
		MOV DH, 26
		MOV DL, 0
		MOV AH, 2			
		INT 10H
		JMP INPUT2
PY:     CALL PLAY               ;放音
		JMP INPUT3

OVER:   MOV AX, 0003				;恢复显示模式
	    INT 10H
        MOV AH, 4CH
	    INT 21H
;---------------------放音---------------------
SONG PROC NEAR
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH BP
	LEA SI, MUS_FREQ
	LEA BP, MUS_TIME

FREQ:
	MOV DI, [SI]
	CMP DI, -1
	JE END_MUS
	MOV BX, DS:[BP]               ;节拍时间送入BX
	CALL SOUND
	ADD SI, 2
	ADD BP, 2
	JMP FREQ
END_MUS:
	POP BP
	POP SI	
	POP DX
	POP CX
	POP BX
	POP AX
	RET
SONG ENDP
RECORDER PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

C1:     MOV AH, 3CH                             ;建立文件
        MOV DX, OFFSET FILENAME
        MOV CX, 0
        INT 21H
        JC C1

C2:     MOV AH, 3DH                             ;打开文件
		MOV AL, 1
		INT 21H
		JC C2
		MOV FILEDES, AX
        ;MOV SI, OFFSET MYDATA
        ;MOV CX, 60000
RCD_1:  MOV DX, 0E49AH
        MOV AL, 1
        OUT DX, AL
        CALL DELAY
        IN AL, DX

        MOV MYDATA[0], AL                       ;写1字节
        MOV AH, 40H
        MOV DX, OFFSET MYDATA
        MOV CX, 1
        MOV BX, FILEDES
        INT 21H

        MOV AH, 1
        INT 16H
        JZ RCD_1
        MOV AH, 7
        INT 21H

        MOV BX, FILEDES
        MOV AH, 3EH
        INT 21H
        POP DX
        POP CX
        POP BX
        POP AX
        RET
RECORDER ENDP

SOUND PROC NEAR
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH DI

	MOV AL, 0B6H                ;8253 计数器2 方波
	OUT 43H, AL                 ;43H 是控制地址
	MOV DX, 12H
	MOV AX, 34DCH               ;1234DCH是输入频率
	DIV DI                      ;计算计数初值，存在AX中
	OUT 42H, AL
	MOV AL, AH
	OUT 42H, AL
	IN AL, 61H
	MOV AH, AL
	OR AL, 3
	OUT 61H, AL
DELAY1:
	MOV CX, 0BBBBH
DL10MS:
	LOOP DL10MS
	DEC BX
	JNZ DELAY1
	MOV AL, AH
	OUT 61H, AL

	POP DI
	POP DX
	POP CX
	POP BX
	POP AX
	RET
SOUND ENDP
;----------------------显示波形-----------------------
WAVE PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
		
C4:     MOV DX, OFFSET FILENAME            ;打开文件
		MOV AH, 3DH
		MOV AL, 0
		INT 21H
		JC C4

		MOV FILEDES, AX                   ;预先取10000个采样数据
        MOV DX, OFFSET MYDATA
        MOV CX, 10000
        MOV BX, FILEDES
        MOV AH, 3FH
        INT 21H
        MOV FILENUM, AX
        
        mov dx,0e4Bbh                     ;设置LED
        mov al,80h
        out dx,al
        mov bx,0h
s0:  
        mov dx,0e4B8h
        mov DI,index
        MOV AL, MYDATA[DI]
        PUSH CX
        MOV CX, 4
        SHR AL, CL
        POP CX
        SUB AL, 6
        SHL AL, 1
        MOV HEIGHT, AL

        push bx
        mov bx, offset pku2               ;输出下                   
        xlat
        pop bx
        out dx,al
     
        mov dx,0e4B9h
        mov AL, HEIGHT

        push bx
        mov bx, offset pku1               ;输出上
        xlat
        pop bx
        out dx,al

        inc index
        mov ax, filenum
        cmp index, ax
        jnz goon
        sub index, ax
        JMP goon
LJ1:    JMP S0
goon:

        mov dx,0e4Bah       ;c
        mov al,bl;09h;bl
        out dx,al
        mov ah,86h
        mov cx,0;4;0;3
        mov dx,90h;0600h;90h
        int 15h
        
        add bl,1h
        cmp bl,010h;0bh;0eh;8;010h
        jnz key0
        mov bl,0
        inc looptimer                        ;整个16列显示了一遍
        cmp looptimer,01fh
        jnz key0
        sub looptimer,01fh
        inc index
        mov ax, filenum
        cmp index, ax
        jnz key0
        sub index, ax

KEY0:   
        mov ah,1                             ;有键按下？
        int 16h
        jz  LJ1
        POP DX
        POP CX
        POP BX
        POP AX
        RET
WAVE ENDP
;------------------------放音------------------------
PLAY PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

C3:     MOV DX, OFFSET FILENAME                   ;打开文件
		MOV AH, 3DH
		MOV AL, 0
		INT 21H
		JC C3
		MOV FILEDES, AX
        ;MOV SI, OFFSET MYDATA
        ;MOV CX, 60000
PLAY_1: MOV DX, OFFSET MYDATA
		MOV BX, FILEDES
		MOV CX, 1
		MOV AH, 3FH
		INT 21H
		CMP AX, 0
		JZ  PLAY_OUT                              ;文件尾？

		MOV DX, 0E490H
        MOV AL, MYDATA[0]
        ;SUB AL, 30H                              ;DONT KNOW THE MEANING?
        OUT DX, AL
        CALL DELAY
        JMP PLAY_1

PLAY_OUT:
        MOV BX, FILEDES
        MOV AH, 3EH
        INT 21H

        POP DX
        POP CX
        POP BX
        POP AX
        RET
PLAY ENDP
;-------------------------延时--------------------------
DELAY PROC NEAR
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        
        MOV AL, 10H
        MOV DX, 0E483H
        OUT DX, AL
        MOV DX, 0E480H
        MOV AL, 200
        OUT DX, AL
        MOV DX, 0E48BH
        MOV AL, 89H
        OUT DX, AL

DLY_1:  MOV DX, 0E48AH         ;READ THE CONTENT FROM PORT C
        IN AL, DX
        CMP AL, 0
        JE DLY_1

        POP DX
        POP CX
        POP BX
        POP AX
        RET
DELAY ENDP
;----------------------绘图-----------------------
INIT PROC NEAR
	MOV AX,DATA
	MOV DS,AX
	MOV AH,0                        
	MOV AL,12H			
	INT 10H                      ;VGA 640*480  16色
	MOV AH,0BH			
	MOV BH,0
	MOV BL,04H                   ;背景色
	INT 10H

        DRAW 300,193,330,198,08H
	DRAW 330,193,360,198,01H
 	DRAW 360,193,390,198,08H
	DRAW 390,193,420,198,01H
	DRAW 420,193,450,198,08H
	DRAW 450,193,480,198,01H
	DRAW 480,193,510,198,08H
	DRAW 510,193,540,198,01H
	DRAW 540,193,570,198,08H

	MOV DH,10			          ;行
	MOV DL,46			          ;列 
	MOV AH,2			          
	INT 10H                       ;置光标位置
	MOV DX,OFFSET TEXT1
	MOV AH,9			
	INT 21H	

	DRAWSQRE 33,440,210,470,01H
	MOV DH,28			
	MOV DL,5			
	MOV AH,2			
	INT 10H
	MOV DX,OFFSET TEXT8
	MOV AH,9			
	INT 21H	
	
	DRAW 300,257,330,262,08H
	DRAW 330,257,360,262,01H
 	DRAW 360,257,390,262,08H
	DRAW 390,257,420,262,01H
	DRAW 420,257,450,262,08H
	DRAW 450,257,480,262,01H
	DRAW 480,257,510,262,08H
	DRAW 510,257,540,262,01H
	DRAW 540,257,570,262,08H

	MOV DH,11			
	MOV DL,38			
	MOV AH,2			
	INT 10H
	MOV DX,OFFSET TEXT6
	MOV AH,9			
	INT 21H

	DRAW 300,304,330,309,08H
	DRAW 330,304,360,309,01H
 	DRAW 360,304,390,309,08H
	DRAW 390,304,420,309,01H
	DRAW 420,304,450,309,08H
	DRAW 450,304,480,309,01H
	DRAW 480,304,510,309,08H
	DRAW 510,304,540,309,01H
	DRAW 540,304,570,309,08H
	
	MOV DH,15			
	MOV DL,38			
	MOV AH,2			
	INT 10H
	MOV DX,OFFSET TEXT2
	MOV AH,9			
	INT 21H
	
	DRAW 300,353,330,358,08H
	DRAW 330,353,360,358,01H
 	DRAW 360,353,390,358,08H
	DRAW 390,353,420,358,01H
	DRAW 420,353,450,358,08H
	DRAW 450,353,480,358,01H
	DRAW 480,353,510,358,08H
	DRAW 510,353,540,358,01H
	DRAW 540,353,570,358,08H
	
	MOV DH,18
	MOV DL,38
	MOV AH,2			
	INT 10H
	MOV DX,OFFSET TEXT5
	MOV AH,9			
	INT 21H

	MOV DH,21
	MOV DL,38
	MOV AH,2			
	INT 10H
	MOV DX,OFFSET TEXT9
	MOV AH,9			
	INT 21H

	;DRAW 265,410,400,419,0BH	
	MOV DH,24
	MOV DL,38	
	MOV AH,2			
	INT 10H
	MOV DX,OFFSET TEXT3
	MOV AH,9			
	INT 21H

	;DRAW 100,122,560,132,0CH	
	MOV DH,13			
	MOV DL,10			
	MOV AH,2			
	INT 10H
	MOV DX,OFFSET TEXT4
	MOV AH,9			
	INT 21H
	
	MOV DH,16			
	MOV DL,7			
	MOV AH,2	
	INT 10H
	MOV DX,OFFSET TEXT7
	MOV AH,9			
	INT 21H
	RET
INIT ENDP

;------------------------录音界面绘制-------------------------
DISP PROC NEAR
	MOV AX,DATA
	MOV DS,AX
	MOV AH,0                        
	MOV AL,12H			
	INT 10H
	MOV AH,0BH			
	MOV BH,0
	MOV BL,04H                 
	INT 10H

    DRAW 300,193,330,198,08H
	DRAW 330,193,360,198,01H
 	DRAW 360,193,390,198,08H
	DRAW 390,193,420,198,01H
	DRAW 420,193,450,198,08H
	DRAW 450,193,480,198,01H
	DRAW 480,193,510,198,08H
	DRAW 510,193,540,198,01H
	DRAW 540,193,570,198,08H

	MOV DH,10			
	MOV DL,46			
	MOV AH,2			
	INT 10H
	MOV DX,OFFSET TEXT10
	MOV AH,9			
	INT 21H	

	DRAW 300,304,330,309,08H
	DRAW 330,304,360,309,01H
 	DRAW 360,304,390,309,08H
	DRAW 390,304,420,309,01H
	DRAW 420,304,450,309,08H
	DRAW 450,304,480,309,01H
	DRAW 480,304,510,309,08H
	DRAW 510,304,540,309,01H
	DRAW 540,304,570,309,08H
	
	MOV DH,15			
	MOV DL,38			
	MOV AH,2			
	INT 10H
	MOV DX,OFFSET TEXT11
	MOV AH,9			
	INT 21H
	
	DRAW 300,353,330,358,08H
	DRAW 330,353,360,358,01H
 	DRAW 360,353,390,358,08H
	DRAW 390,353,420,358,01H
	DRAW 420,353,450,358,08H
	DRAW 450,353,480,358,01H
	DRAW 480,353,510,358,08H
	DRAW 510,353,540,358,01H
	DRAW 540,353,570,358,08H
	
	MOV DH,18
	MOV DL,38
	MOV AH,2			
	INT 10H
	MOV DX,OFFSET TEXT12
	MOV AH,9			
	INT 21H

	MOV DH,21
	MOV DL,38
	MOV AH,2			
	INT 10H
	MOV DX,OFFSET TEXT13
	MOV AH,9			
	INT 21H

	;DRAW 265,410,400,419,0BH	
	MOV DH,24
	MOV DL,38	
	MOV AH,2			
	INT 10H
	MOV DX,OFFSET TEXT3
	MOV AH,9			
	INT 21H
	RET
DISP ENDP

;--------------------------------- END --------------------------------------
CODE ENDS
	END START





