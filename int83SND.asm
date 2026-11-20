.8086
.model tiny
.code
   org 100h
start:
  jmp main

Funcion PROC FAR
  sti
  pushf
  push ax
  push bx
  push cx
  push dx


  mov dx, 16000       
play:
      mov bx, 1      

      mov ax, dx
      out 42h, al
      mov al, ah
      out 42h, al

      in al, 61h
      or al, 00000011b
      out 61h, al

pause1:
      push dx
      mov cx, 100
pause2:
      dec cx
      jnz pause2
      dec bx
      jnz pause1
      pop dx

      in  al, 61h
      and al, 11111100b
      out 61h, al

      dec dx        
      jnz play

  pop dx
  pop cx
  pop bx
  pop ax
  popf
  iret
endp


DespIntXX dw 0
SegIntXX  dw 0

FinResidente LABEL BYTE   

Cartel    DB "Programa Instalado exitosamente!!!",0dh, 0ah, '$'

main:        
  mov ax,CS
  mov DS,ax
  mov ES,ax

InstalarInt:
  mov AX,3583h        
  int 21h    
       
  mov DespIntXX,BX    
  mov SegIntXX,ES

  mov AX,2583h    
  mov DX,Offset Funcion 
  int 21h

MostrarCartel:
  mov dx, offset Cartel
  mov ah,9
  int 21h

DejarResidente:   
  Mov     AX,(15 + offset FinResidente) 
  Shr     AX,1            
  Shr     AX,1        
  Shr     AX,1    
  Shr     AX,1
  Mov     DX,AX           
  Mov     AX,3100h    
  Int     21h         
end start
