.8086 
.model small
.stack 100h 
.data 
		cartel			db "---------------Flappy Bird--------------", 0dh, 0ah
						db "1. iniciar el juego", 0dh, 0ah
						db "2. historial", 0dh, 0ah
						db "3. salir", 0dh, 0ah, 24h

		error1			db "error: ingrese una opcion que este en el menu", 0dh, 0ah, 24h

		entre			db 0dh, 0ah, 24h
.code
	main proc
		mov ax, @data
		mov ds, ax

		call clearscreen

		mov ah, 09h				;printeo el menu
		lea dx, cartel
		int 21h

		call menu				;llamo a la funcion para mostrar el meni y leer la eleccion

		mov ax, 4c00h
		int 21h
	main endp


	menu proc
		push ax
		push dx

		forMenu:
			mov ah, 01h				
			int 21h
			
			cmp al, 31h				;comparo si es 1 para iniciar el juego
			je star
			
			cmp al, 32h				;comparo si es 2 para mostrar el historial
			je hist
				
			cmp al, 33h				;comparo si es 3 asi salgo del juego 
			je quit
			

			call clearscreen


			mov ah, 09h				;printeo el menu
			lea dx, cartel
			int 21h

			mov ah, 09h				;hago un enter
			lea dx, entre
			int 21h

			mov ah, 09h				;printeo el menu
			lea dx, error1
			int 21h

		jmp forMenu

		star:
			call clearscreen

			call inicio

		hist:
			call clearscreen

			call historial

		quit:

		pop dx 
		pop ax
		ret
	menu endp

	Clearscreen proc
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
	Clearscreen endp
end 
