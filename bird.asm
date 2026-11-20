.8086 
.model small
.stack 100h 
.data 
	cartel  		db " |     | ", 54 dup(' '), 														" |     | ", 0dh, 0ah
           			db " |     | ", 54 dup(' '), 														" |     | ", 0dh, 0ah
           			db " [=====] ", 54 dup(' '), 														" [=====] ", 0dh, 0ah
           			db 9 dup(' '),	" _____ _", 27 dup(' '), 						 " ____  _         _ ", 0dh, 0ah
           			db 9 dup(' '), 	"|  ___| | __ _ _ __  _ __  _   _ ", 2 dup(' '), "| __ )(_)_ __ __| |", 0dh, 0ah
           			db 9 dup(' '), 	"| |_  | |/ _` | '_ \| '_ \| | | |", 2 dup(' '), "|  _ \| | '__/ _` |", 0dh, 0ah
           			db 9 dup(' '), 	"|  _| | | (_| | |_) | |_) | |_| |", 2 dup(' '), "| |_) | | | | (_| |", 0dh, 0ah
           			db 9 dup(' '), 	"|_|   |_|\__,_| .__/| .__/ \__, |", 2 dup(' '), "|____/|_|_|  \__,_|", 0dh, 0ah
           			db 23 dup(' '), 			  "|_|   |_|    |___/", 0dh, 0ah
           			db " [=====] ", 21 dup(' '), "    ,--.    ", 21 dup(' '), 							" [=====] ", 0dh, 0ah
           			db " |     | ", 21 dup(' '), " ~~(  o )>  ", 21 dup(' '), 							" |     | ", 0dh, 0ah
           			db " |     | ", 21 dup(' '), "    `--'    ", 21 dup(' '), 							" |     | ", 0dh, 0ah
           			db 72 dup('#'), 0dh, 0ah
            		db 26 dup(' '), "1. iniciar el juego", 0dh, 0ah
            		db 26 dup(' '), "2. historial", 0dh, 0ah
            		db 26 dup(' '), "3. salir", 0dh, 0ah, 24h

	agradecimiento	db 02h 	   ," gracias por haber jugado a nuestro juego y por la cursada, los queremos Fabio y Pedro ",02h , 0dh, 0ah, 24h

	entre			db 0dh, 0ah, 24h

	error1			db 			"error: ingrese una opcion que este en el menu"			   	 , 0dh, 0ah, 24h
.code
	extrn clearscreen:proc
	extrn leer:proc
	extrn escribir:proc
	extrn juego:proc

	main proc
		mov ax,@data
		mov ds,ax

		call clearscreen
		
		mov ah, 09h
		lea dx, cartel
		int 21h

		forMenu:	;━━━━━━━━━━━━━━━━━━━━━━━━━━━━
			mov ah, 01h							;|
			int 21h								;|
												;|
			cmp al, 31h							;|
			je start							;|
												;|
			cmp al, 32h							;|
			je historial						;|
												;|
			cmp al, 33h							;|
			je quit								;|
												;| Acá se codifica el menú. El programa espera a que el usuario apriete una tecla y revisa si fue 1, 2 o 3
			call clearscreen					;| para mandarlo a la opción correspondiente. Si apretó cualquier otra cosa, muestra un mensaje de error
												;| y vuelve a pedir la opción.
			mov ah, 09h							;|
			lea dx, cartel						;|
			int 21h								;|
												;|
			mov ah, 09h							;|
			lea dx, entre						;|
			int 21h								;|
												;|
			mov ah, 09h							;|
			lea dx, error1						;|
			int 21h								;|
												;|
			jmp forMenu							;|
					;━━━━━━━━━━━━━━━━━━━━━━━━━━━━

		start: 		;━━━━━━━━━━━━━━━━━━━━━━━━━━━━
			call juego							;|
			call clearscreen					;|
			mov ah, 09h							;| En esta parte se codifica la entrada al juego. Se ejecuta el juego y, cuando el jugador termina,
			lea dx, cartel						;| se limpia la pantalla y se vuelve a mostrar el menú.
			int 21h								;|
			jmp forMenu							;|
					;━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		
		historial:	;━━━━━━━━━━━━━━━━━━━━━━━━━━━━						
			call clearscreen					;|
			call leer 							;|
												;|
			mov ah, 01h							;|	
			int 21h								;| La funcion historial muestra la pantalla del historial en si. Se muestran los puntajes guardados de 
												;| partidas anteriores y se espera a que el usuario apriete una tecla para que alcance a leerlos.
			call clearscreen					;| Después se vuelve al menú.
			mov ah, 09h							;|
			lea dx, cartel						;|
			int 21h								;|
			jmp forMenu							;|
					;━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		
		quit:		;━━━━━━━━━━━━━━━━━━━━━━━━━━━━
			call clearscreen					;|
			mov ah, 09h							;| La funcion Quit nos manda a la salida del juego, en donde hay un mensaje de agradecimiento 
			lea dx, agradecimiento				;| y cierra el programa.
			int 21h								;|
					;━━━━━━━━━━━━━━━━━━━━━━━━━━━━

		mov ax, 4c00h
		int 21h
	main endp
end 
