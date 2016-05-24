data segment
;pku1  db 0ffh, 7fh, 3fh, 1fh, 0fh, 07h, 03h, 01h, 01h, 03h, 07h, 0fh, 1fh, 3fh, 7fh, 0ffh
;pku2  db 01h, 03h, 07h, 0fh, 1fh, 3fh, 7fh, 0ffh, 0ffh, 7fh, 3fh, 1fh, 0fh, 07h, 03h, 01h
pku1   db 0ffh, 81h, 81h, 42h, 3ch, 0ffh,02h, 08h, 020h,080h,0ffh,00h, 00h, 00h, 00h, 0ffh
pku2   db 0ffh, 00h, 00h, 00h, 00h, 0ffh,040h,010h,04h, 01h, 0f8h,02h, 01h, 01h, 02h, 0f8h
;          1     1    1    0    0    1    0    0    0    1    1    0    0    0    0    1
;          1     0    0    1    0    1    0    0    0    0    1    0    0    0    0    1
;          1     0    0    0    1    1    0    0    1    0    1    0    0    0    0    1
;          1     0    0    0    1    1    0    0    0    0    1    0    0    0    0    1
;          1     0    0    0    1    1    0    1    0    0    1    0    0    0    0    1
;          1     0    0    0    1    1    0    0    0    0    1    0    0    0    0    1
;          1     0    0    1    0    1    1    0    0    0    1    0    0    0    0    1
;          1     1    1    0    0    1    0    0    0    0    1    0    0    0    0    1

;          1     0    0    0    0    1    0    0    0    0    1    0    0    0    0    1
;          1     0    0    0    0    1    1    0    0    0    1    0    0    0    0    1
;          1     0    0    0    0    1    0    0    0    0    1    0    0    0    0    1
;          1     0    0    0    0    1    0    1    0    0    1    0    0    0    0    1
;          1     0    0    0    0    1    0    0    0    0    1    0    0    0    0    1
;          1     0    0    0    0    1    0    0    1    0    0    0    0    0    0    0
;          1     0    0    0    0    1    0    0    0    0    0    1    0    0    1    0
;          1     0    0    0    0    1    0    0    0    1    0    0    1    1    0    0

index db  00h
looptimer db 00h
data ends
code segment
     assume cs:code, ds:data
start:
     mov ax,data
     mov ds,ax

     mov dx,0d40bh;0e48bh
     mov al,80h
     out dx,al
     mov bx,0h
s0:  
     mov dx,0d408h;0e488h       ;a
     ;mov al,07eh;33h
     mov al,index

     push bx
     mov bx, offset pku2
     xlat
     pop bx

     out dx,al
     mov dx,0d409h;0e489h
     ;mov al,0feh;088h    ;b

     mov al,index
     ;inc index
     ;cmp index,010h
     ;jnz goon
     ;sub index,010h

     push bx
     mov bx, offset pku1
     xlat
     pop bx

     out dx,al

    inc index
    cmp index, 010h
    jnz goon
    sub index, 010h

goon:

     mov dx,0d40ah;;0e48ah       ;c
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
inc looptimer
cmp looptimer,04fh
jnz key0
sub looptimer,04fh
inc index
cmp index, 010h
jnz key0
sub index, 010h
key0:
    mov ah,1
    int 16h
    jz  s0
    mov ah,4ch
    int 21h
code ends
end  start
