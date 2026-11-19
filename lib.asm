.8086
.model small
.stack 100h
.data   					   			;━━━━━━━
	archivo		db 'his.txt',0	      			|
	filehandler	dw 0		     	  			|  
					                 			|  En esta parte se guardan los datos que usa la libreria
	len		equ 1		             			|  
	buf		db 1 dup(?)	              			|  
	cola		db '$'		          			|
	errmsg		db 10,13,'Error apertura Archivo UNO.TXT!',10,13,'$'
	cantreng	db 39		          			|
                			   			;━━━━━━━
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
			uno:                      ;━━━━━━━
				mov ax,@data                  |
			    mov ds,ax                     |  Se prepara todo para leer el historial.
				                              |  Se limpia la pantalla y se abre el archivo his.txt.
				call clearscreen              |  Si el archivo no existe o no se puede abrir, el programa
			                                  |  salta directo al mensaje de error.
			    lea dx,archivo                |
			    mov ax,3d00h                  |
			    int 21h                       |
			                                  |
			    jc wrong                      |
			    mov filehandler,ax    ;━━━━━━━

			otrocar:                  ;━━━━━━━
				mov bx,filehandler            |
			    mov ah,3fh                    |
			    mov cx,len                    |  Aca esta la parte principal de leer. Lee el archivo
			                                  |  de a una letra por vez y la muestra en pantalla. Cuando llega
			    lea dx,buf                    |  al final del archivo, termina de leer. Si la letra leida es un
			    int 21h                       |  salto de linea, va a revisar si hay que cambiar de pagina.
			                                  |  Si no, sigue con la proxima letra.
			    cmp ax,0                      |
				je endoffile                  |
				                              |
				lea dx, buf                   |
			    mov ah,9                      |
				int 21h                       |
				                              |
				cmp buf,0Ah                   |
				je checkpage                  |
				                              |
				jmp otrocar           ;━━━━━━━

			checkpage:                ;━━━━━━━
				push bx                       |
				push di                       |
				                              |
				mov bl, cantreng              |  Esta parte cuenta los renglones que se van mostrando. La idea es que
				                              |  cuando la pantalla se llena de renglones (39), se limpie y se siga
				inc bl                        |  mostrando el resto del historial en una pantalla nueva. Despues
				                              |  vuelve a seguir leyendo letras.
				cmp bl,39                     |
				jne sigo123                   |
				                              |
				call clearscreen              |
			sigo123:                          |
				mov bl,0                      |
				inc bl                        |
				                              |
				lea di,cantreng               |
				                              |
				mov byte ptr[di],bl           |
				                              |
				pop di                        |
				pop bx                        |
				jmp otrocar           ;━━━━━━━

			endoffile:                ;━━━━━━━
				mov bx,filehandler            |  Se ejecuta cuando ya se leyo todo el historial.
				mov ah,3eh                    |  Cierra el archivo para dejarlo libre.
			    int 21h                       |
			    jmp fin               ;━━━━━━━

			wrong:                    ;━━━━━━━
				lea dx,errmsg                 |  Si hubo un problema al abrir el archivo
			    mov ah,9                      |  Muestra un mensaje de error en pantalla.
			    int 21h               ;━━━━━━━

			fin:                      ;━━━━━━━
				mov ah,4ch                    |  y se termina la funcion leer. Termina el programa.
			    int 21h               ;━━━━━━━
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

	clearscreen proc                  ;━━━━━━━
		push ax                               |
		push es                               |
		push cx                               |
		push di                               |
		                                      |
		mov ax,3                              |  La funcion clearscreen limpia la pantalla. Primero reinicia el modo
		int 10h                               |  de video (lo que ya borra todo) y despues recorre la memoria de
		                                      |  video pisando cada posicion con espacios en blanco para
		mov ax,0b800h                         |  asegurarse de que no quede nada escrito.
		mov es,ax                             |
		mov cx,1000                           |
		mov ax,7                              |
		mov di,ax                             |
		                                      |
		cld                                   |
		                                      |
		rep stosw                             |
		                                      |
		pop di                                |
		pop cx                                |
		pop es                                |
		pop ax                                |
		ret                                   |
	clearscreen endp                  ;━━━━━━━
end
