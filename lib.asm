.8086
.model small 
.stack 100h
.data
	archivo				db 'his.txt',0	;nombre del archivo a leer o escribir
	filehandler			dw 0			
	
	len			equ 1
	buf		db 1 dup(?)		;buffer de lectura del archivo 1
	cola		db '$'
	errmsg		db 10,13,'Error apertura Archivo UNO.TXT!',10,13,'$'
	cantreng	db 39

.code
	public clearscreen
	public leer
	
	leer proc
		push ax
		push bx
		push ds
		push di
		push dx
		push cx
			uno:
				mov ax,@data
			    mov ds,ax
				
				call clearscreen
			    
			    lea dx,archivo
			    mov ax,3d00h
			    int 21h
			    
			    jc wrong
			    mov filehandler,ax
			    
			otrocar:
				mov bx,filehandler
			    mov ah,3fh
			    mov cx,len
			    
			    lea dx,buf
			    int 21h
			    
			    cmp ax,0
				je endoffile
				
				lea dx, buf 
			    mov ah,9
				int 21h
				
				cmp buf,0Ah
				je checkpage
				
				jmp otrocar

			checkpage:
				push bx
				push di
				
				mov bl, cantreng
				
				inc bl
				
				cmp bl,39
				jne sigo123
				
				call clearscreen
			sigo123:
				mov bl,0
				inc bl
				
				lea di,cantreng
				
				mov byte ptr[di],bl
				
				pop di
				pop bx
				jmp otrocar
				
			endoffile:				
				mov bx,filehandler 	; coloco en BX el file handler del archivo abierto
				mov ah,3eh
			    int 21h        ;cierra archivo
			    jmp fin

			wrong:    
				lea dx,errmsg
			    mov ah,9
			    int 21h        ;muestra mensaje de error
			fin:
				mov ah,4ch
			    int 21h        ;retorna al ss oo
		push ax
		push bx
		push ds
		push di
		push dx
		push cx

		pop cx
		pop dx
		pop di
		pop ds 
		pop bx
		pop ax
		ret
	leer endp

	clearscreen proc 
		push ax
		push es
		push cx
		push di
		
		mov ax,3
		int 10h
		
		mov ax,0b800h
		mov es,ax
		mov cx,1000
		mov ax,7
		mov di,ax
		
		cld
		
		rep stosw
		
		pop di
		pop cx
		pop es
		pop ax
		ret 
	clearscreen endp
end
