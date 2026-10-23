.8086 
.model small
.stack 100h 
.data 
		cartel			db "---------------Flappy Bird--------------", 0dh, 0ah
						db "1. iniciar el juego", 0dh, 0ah
						db "2. historial", 0dh, 0ah
						db "3. salir", 0dh, 0ah, 24h

		error1			db "error: ingrese una opcion que este en el menu", 0dh, 0ah, 24h

		entre		db 0dh, 0ah, 24h

		eleccion 		db "0", 0dh, 0ah, 24h
.code
	main proc
		mov ax, @data
		mov ds, ax

		call menu				;llamo a la funcion para mostrar el meni y leer la eleccion

		mov ax, 4c00h
		int 21h
	main endp


	menu proc
		push ax
		push dx

		forMenu:

			mov ah, 09h				;printeo el menu
			lea dx, cartel
			int 21h


			mov ah, 01h				
			int 21h

			cmp al, 31h				;comparo si es 1 para iniciar el juego
			je guardar
			
			cmp al, 32h				;comparo si es 2 para mostrar el historial
			je guardar
				
			cmp al, 33h				;comparo si es dos asi salgo del juego 
			je guardar
			

			mov ah, 09h				;hago un enter
			lea dx, entre
			int 21h

			mov ah, 09h				;printeo el menu
			lea dx, error1
			int 21h

		jmp forMenu

		guardar:
			mov eleccion[0], al	    ;guardo la opcion del usuario


		pop dx 
		pop ax
		ret
	menu endp
end 