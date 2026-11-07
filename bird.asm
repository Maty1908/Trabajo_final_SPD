.8086 
.model small
.stack 100h 
.data 

.code
	extrn menu:proc

	main proc
		mov ax, @data
		mov ds, ax

			call menu				;llamo a la funcion para mostrar el menu y leer la eleccion

		mov ax, 4c00h
		int 21h
	main endp

end 
