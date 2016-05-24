data     segment
luport   equ 0d41ah;equ 29ah                              ;Â¼Òô¿ÚµØÖ·
fangport equ 0d410h;equ 290h                              ;·ÅÒô¿ÚµØÖ·
data_qu  db 60000 dup(?)                         ;Â¼ÒôÊý¾Ý´æ·ÅÊý¾ÝÇø
news_1   db 'Press any key to record:',24h       ;Â¼ÒôÌáÊ¾
news_2   db 0dh,0ah,' Playing:',24h              ;·ÅÒôÌáÊ¾
data     ends
code     segment
	 assume cs:code,ds:data,es:data
begin:   mov ax,data                              ;³õÊ¼»¯
	 mov  ds,ax
	 mov es,ax
	 mov  dx,offset news_1                    ;ÏÔÊ¾Â¼ÒôÌáÊ¾
	 mov  ah,9
	 int  21h
test_1:	 mov  ah,1                                ;µÈ´ý¼üÅÌÊäÈë
	 int  16h
	 jz  test_1                               ;Èô²»ÊÇÔòÑ­»·µÈ´ý
	 call  lu                                 ;µ÷ÓÃÂ¼Òô×Ó³ÌÐò
	 mov dx,offset news_2                     ;ÏÔÊ¾·ÅÒôÌáÊ¾
	 mov ah,9
	 int 21h
fy: 	 call fang                                ;µ÷ÓÃ·ÅÒô×Ó³ÌÐò
	 mov ax,0c07h
	 int 21h
	 cmp al,20h
	 jz fy
	 mov ah,4ch                              ;·µ»ØDOS
	 int 21h
lu      proc near                                ;Â¼Òô×Ó³ÌÐò
	 mov di,offset data_qu                   ;ÖÃÊý¾ÝÇøÊ×µØÖ·ÎªDI
	 mov cx,60000                            ;Â¼60000¸öÊý¾Ý
	 cld
xunhuan:mov dx,luport                             ;Æô¶¯A/D
	out dx,al
	call delay                               ;ÑÓÊ±
	in al,dx                                 ;´ÓA/D¶ÁÊý¾Ýµ½AL
	stosb                                    ;´æÈëÊý¾ÝÇø,Ê¹DI¼Ó1
	loop xunhuan                             ;Ñ­»·
	ret                                      ;×Ó³ÌÐò·µ»Ø
 lu     endp
fang   proc near                                  ;·ÅÒô×Ó³ÌÐò
	 mov cx,60000                            ;·Å60000¸öÊý¾Ý
	 mov si,offset data_qu                   ;ÖÃÊý¾ÝÇøÊ×µØÖ·ÎªSI
	 cld
fang_yin: mov dx,fangport
	 lodsb                                   ;´ÓÊý¾ÝÇøÈ¡³öÊý¾Ý
	 sub al,30h
	 out dx,al                               ;·ÅÒô
	 call delay                              ;ÑÓÊ±
	 loop fang_yin                           ;Ñ­»·
	 ret                                     ;×Ó³ÌÐò·µ»Ø
fang     endp
delay	proc	near                             ;ÑÓÊ±×Ó³ÌÐò
	push dx
	mov	al,10h                           ;Éè8253Í¨µÀ0¹¤×÷·½Ê½0
        mov     dx,0d403h;283h
	out	dx,al
	mov	al,200                           ;Ð´Èë¼ÆÊýÆ÷³õÖµ200
        mov     dx,0d400h;280h
	out	dx,al
        mov     dx,0d40bh;28bh                            ;Éè8255µÄA¿ÚÎªÊäÈë
        mov     al,9bh
        out     dx,al
        mov     dx,0d408h;288h                              ;´Ó8255µÄA¿ÚÊäÈë
delay1: in      al,dx
        and     al,1                                 ;ÅÐ¶ÏPA0ÊÇ·ñÎª1
	jz	delay1                             ;ÈôPA0²»Îª1,×ªde_lay
	pop dx
	ret                                       ;×Ó³ÌÐò·µ»Ø
delay	endp
	 code ends
	 end begin
