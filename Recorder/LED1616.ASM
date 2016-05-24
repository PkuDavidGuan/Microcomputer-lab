code segment
     assume cs:code
start:
     mov dx,0d40bh;0e48bh
     mov al,80h
     out dx,al
     mov bx,0h
s0:  
     mov dx,0d408h;0e488h       ;c
     mov al,0ffh;33h
     out dx,al
     mov dx,0d409h;0e489h
     mov al,0ffh;088h    ;c
     out dx,al

     mov dx,0d40ah;0e48ah       ;r
     mov al,bl;09h;bl
     out dx,al
mov ah,86h
mov cx,0;4;0;3
mov dx,0600h;90h
int 15h
add bl,1h
cmp bl,010h;0bh;0eh;8;010h
jnz key0
mov bl,0
key0:
    mov ah,1
    int 16h
    jz  s0
    mov ah,4ch
    int 21h
code ends
end  start
