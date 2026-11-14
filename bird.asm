.8086 
.model small
.stack 100h 
.data 
	cartel			db "---------------Flappy Bird--------------"	, 0dh, 0ah
					db "1. iniciar el juego"						, 0dh, 0ah
					db "2. historial"								, 0dh, 0ah
					db "3. salir"									, 0dh, 0ah, 24h

	agradecimiento	db "gracias por haber jugado a nuestro juego y por la cursada", 0dh, 0ah, 24h

	entre			db 0dh, 0ah, 24h

	error1			db "error: ingrese una opcion que este en el menu", 0dh, 0ah, 24h
.code
	extrn clearscreen:proc
	extrn leer:proc

	main proc
		mov ax,@data
		mov ds,ax

		call clearscreen

		mov ah, 09h
		lea dx, cartel
		int 21h

		forMenu:
			mov ah, 01h				
			int 21h
			
			cmp al, 31h				;si es 1 arranco el juego 
			je start
				
			cmp al, 32h				;si es 2 abre el historial
			je historial
					
			cmp al, 33h				;si es 3 sale del juego 
			je quit

			call clearscreen

			mov ah, 09h
			lea dx, cartel
			int 21h

			mov ah, 09h
			lea dx, entre
			int 21h

			mov ah, 09h
			lea dx, error1
			int 21h

			jmp forMenu

		start:
			call clearscreen
			jmp quit


		historial:
			call clearscreen
			call leer 
			jmp quit

		quit:
			call clearscreen
			mov ah, 09h
			lea dx, agradecimiento
			int 21h

		mov ax, 4c00h
		int 21h
	main endp
end 
