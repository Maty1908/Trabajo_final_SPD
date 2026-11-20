.8086
.model small 
.stack 100h
.data
	archivo						db "his.txt", 0
	filehandler					dw 0			
	len							equ 1
	buf							db 1 dup(?)
	errmsg						db "Error apertura Archivo his.txt!", 0ah, 0dh, 24h
	cantreng					db 0

	filehandlerEscritura		dw 0
	
	puntajeActual				dw 0
	puesto1						dw 0
	puesto2						dw 0
	puesto3						dw 0

	bufferLectura				db 1500 dup(0)

	textoAEscribir				db 				" |     |                                                        |     |", 0dh, 0ah
								db				" |     |                                                        |     |", 0dh, 0ah
								db				" [=====]                                                        [=====]", 0dh, 0ah
								db				"          _____ _                            ____  _         _         ", 0dh, 0ah
								db				"         |  ___| | __ _ _ __  _ __  _   _   | __ )(_)_ __ __| |        ", 0dh, 0ah
								db				"         | |_  | |/ _` | '_ \| '_ \| | | |  |  _ \| | '__/ _` |        ", 0dh, 0ah
								db				"         |  _| | | (_| | |_) | |_) | |_| |  | |_) | | | | (_| |        ", 0dh, 0ah
								db				"         |_|   |_|\__,_| .__/| .__/ \__, |  |____/|_|_|  \__,_|        ", 0dh, 0ah
								db				"                       |_|   |_|    |___/                              ", 0dh, 0ah
								db				" [=====]                          ,--.                          [=====]", 0dh, 0ah
								db				" |     |                       ~~(  o )>                        |     |", 0dh, 0ah
								db				" |     |                          `--'                          |     |", 0dh, 0ah
								db				"########################################################################", 0dh, 0ah
                          		db				"--- HISTORIAL ---", 0dh, 0ah 
	linea1						db 				"1ro: 000", 0dh, 0ah
	linea2						db 				"2do: 000", 0dh, 0ah
	linea3						db 				"3ro: 000", 0dh, 0ah
								db 0dh, 0ah,	"aprete cualquier tecla para volver al menu", 0dh, 0ah

	longitudTexto				equ $ - textoAEscribir

.code
	public clearscreen
	public leer
	public escribir
	
	leer proc
		push ax
		push bx
		push ds
		push di
		push dx
		push cx

		mov ax, @data
		mov ds, ax

		call clearscreen

		lea dx, archivo
		mov ax, 3d00h
		int 21h
		jc wrong
		mov filehandler, ax

		otrocar:
			mov bx, filehandler
			mov ah, 3fh
			mov cx, len
			lea dx, buf
			int 21h

			cmp ax, 0
			je endoffile

			mov dl, buf
			mov ah, 02h
			int 21h

			cmp buf, 0Ah
			je checkpage
			jmp otrocar

		checkpage:
			push bx
			push di
			
			mov bl, cantreng
			inc bl
			cmp bl, 39
			jl sigo123
			
			call clearscreen
			mov bl, 0
			
		sigo123:
			mov cantreng, bl
			
			pop di
			pop bx
			jmp otrocar
			
		endoffile:				
			mov bx, filehandler 
			mov ah, 3eh
			int 21h
			jmp fin_leer

		wrong:    
			lea dx, errmsg
			mov ah, 9
			int 21h

		fin_leer:
			pop cx
			pop dx
			pop di
			pop ds 
			pop bx
			pop ax
			ret
	leer endp
	
	escribir proc
		push ax
		push bx
		push cx
		push dx
		push di
		push si
		push ds

		mov bx, @data
		mov ds, bx

		mov [puntajeActual], ax

		mov ax, 3d00h
		lea dx, archivo
		int 21h
		jc saltar_comparacion
		mov filehandler, ax

		mov ah, 3fh
		mov bx, filehandler
		mov cx, 1400
		lea dx, bufferLectura
		int 21h

		mov ah, 3eh
		mov bx, filehandler
		int 21h

		lea si, bufferLectura + (linea1 - textoAEscribir) + 5
		call ascii_a_num
		mov [puesto1], bx

		lea si, bufferLectura + (linea2 - textoAEscribir) + 5
		call ascii_a_num
		mov [puesto2], bx

		lea si, bufferLectura + (linea3 - textoAEscribir) + 5
		call ascii_a_num
		mov [puesto3], bx

		saltar_comparacion:
			mov ax, [puntajeActual]

			mov bx, [puesto1]
			cmp ax, bx
			jle comprobar_puesto2

			mov cx, [puesto2]
			mov [puesto3], cx
			mov cx, [puesto1]
			mov [puesto2], cx
			mov [puesto1], ax
			jmp actualizar_cadenas

		comprobar_puesto2:
			mov bx, [puesto2]
			cmp ax, bx
			jle comprobar_puesto3

			mov cx, [puesto2]
			mov [puesto3], cx
			mov [puesto2], ax
			jmp actualizar_cadenas

		comprobar_puesto3:
			mov bx, [puesto3]
			cmp ax, bx
			jle fin_sin_cambios

			mov [puesto3], ax

		actualizar_cadenas:
			mov ax, [puesto1]
			lea di, linea1 + 5
			call num_a_ascii

			mov ax, [puesto2]
			lea di, linea2 + 5
			call num_a_ascii

			mov ax, [puesto3]
			lea di, linea3 + 5
			call num_a_ascii

			mov ah, 3Ch
			mov cx, 0
			lea dx, archivo			
			int 21H
			jc fin_sin_cambios
			mov word ptr [filehandlerEscritura], ax      

			mov ah, 40h
			mov bx, word ptr [filehandlerEscritura] 
			mov cx, longitudTexto          
			lea dx, textoAEscribir         
			int 21H

			mov ah, 3Eh
			mov bx, word ptr [filehandlerEscritura]
			int 21H

		fin_sin_cambios:
			pop ds
			pop si
			pop di
			pop dx
			pop cx
			pop bx
			pop ax
			ret
	escribir endp

	num_a_ascii proc
		push ax
		push bx
		push cx
		push dx

		mov cx, 3
		mov bx, 10

		division_loop:
			xor dx, dx
			div bx
			add dl, 30h
			push dx
			loop division_loop

			mov cx, 3
		pop_loop:
			pop dx
			mov [di], dl
			inc di
			loop pop_loop

			pop dx
			pop cx
			pop bx
			pop ax
			ret
	num_a_ascii endp

	ascii_a_num proc
		push ax
		push cx
		push dx
		push si

		mov al, [si]
		sub al, 30h
		mov ah, 0
		mov cx, 100
		mul cx
		mov bx, ax

		mov al, [si+1]
		sub al, 30h
		mov ah, 0
		mov cx, 10
		mul cx
		add bx, ax

		mov al, [si+2]
		sub al, 30h
		mov ah, 0
		add bx, ax

		pop si
		pop dx
		pop cx
		pop ax
		ret
	ascii_a_num endp

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
