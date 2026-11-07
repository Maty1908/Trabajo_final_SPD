.8086
.model small
.stack 100
.data
len				equ 1
encabezado		db '--- HISTORIAL ---',0dh ,0ah ,'$'
arch1			db 'HIS.TXT',0					;un archivo, debe estar en la misma carpeta del ejecutable
buf1			db 1 dup(?)						;buffer de lectura del archivo 1
cola			db '$'
error			db 10,13,'Error apertura Archivo historial!',0dh ,0ah ,24h
fiha1			dw ?							; file handler del archivo abierto
cantreng		db 39

.code
	public leer
	extrn clearscreen:proc


	leer proc


		hist:
			mov ax,@data
		    mov ds,ax    			; lo de siempre

			call clearscreen

		    lea dx,arch1
		    mov ax,3d00h			;abre el historial
		    int 21h        			

		    jc wrong		
		    mov fiha1,ax  			; muevo a fiha1 el file handler del archivo abierto
			lea dx, encabezado 
		    mov ah,9
			int 21h        			;muestra caracter leido
		    
		otrocar:
			mov bx,fiha1 	; coloco en BX el file handler del archivo abierto
		    mov ah,3fh
		    mov cx,len
		    lea dx,buf1
		    int 21h        ;lee archivo 1 en buf1
		    cmp ax,0
			je endoffile
			lea dx, buf1 
		    mov ah,9
			int 21h        ;muestra caracter leido
			cmp buf1,0Ah
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
			cmp bl,39
			mov bl,0
			inc bl
			lea di,cantreng
			mov byte ptr[di],bl
			pop di
			pop bx
			jmp otrocar
			
		endoffile:
			
			mov bx,fiha1 	; coloco en BX el file handler del archivo abierto
			mov ah,3eh
		    int 21h        ;cierra arch1
		    jmp fin

		wrong:    
			lea dx,error
		    mov ah,9
		    int 21h        ;muestra mensaje de error
		fin:
			mov ah,4ch
		    int 21h        ;retorna al ss oo
	leer endp
end