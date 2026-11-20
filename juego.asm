.8086
.model small
.stack 100h

.data
    salir           dw 0
    flag_salto      dw 0
    salto           dw 0


    pajaro_x        dw 15
    pajaro_y        dw 10
    char_pajaro     db '>'         
    attr_pajaro     db 0Eh          

    ancho_tubo      dw 3           
    alto_hueco      dw 5         
    suelo_y         dw 23          
    puntos          dw 0

    tubo1_x         dw 50
    tubo1_hueco_y   dw 6
    tubo1_pasado    dw 0

    tubo2_x         dw 82
    tubo2_hueco_y   dw 11
    tubo2_pasado    dw 0

    char_tubo       db '#'        
    attr_tubo       db 02h         

    char_suelo      db '='         
    attr_suelo      db 06h        

    attr_vacio      db 07h        


    texto_perdiste      db "PERDISTE!", 0
    texto_puntos        db "PUNTOS:", 0
    texto_reintentar    db "[ESPACIO] Reintentar", 0
    texto_salir         db "[ESC] Volver al menu", 0
    numero              db 6 dup(0)

.code
    public juego
    extrn escribir:proc

    juego proc
        push ax
        push bx
        push cx
        push dx
        push si
        push di
        push es

        mov ax, @data
        mov ds, ax

        mov ax, 0B800h
        mov es, ax

        mov ax, 0003h
        int 10h

    reiniciar_partida:
        mov salir, 0
        mov flag_salto, 0
        mov salto, 0
        mov pajaro_x, 15
        mov pajaro_y, 10
        mov puntos, 0
        mov tubo1_x, 50
        mov tubo1_hueco_y, 6
        mov tubo1_pasado, 0
        mov tubo2_x, 82
        mov tubo2_hueco_y, 11
        mov tubo2_pasado, 0

        xor bx, bx 
        xor dx, dx 

        ciclo:
            call teclado
            cmp salir, 1
            je finJuego

            call parte_logica 
            call parte_grafica  

            cmp dx, 1
            je ir_game_over

            call esperar_paso    
            jmp ciclo

        ir_game_over:
            int 83h
            mov ax, puntos
            call escribir

            call pantalla_final
            cmp salir, 1
            je finJuego
            jmp reiniciar_partida

        finJuego:
            call limpiar_pantalla

        pop es
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    juego endp

    teclado proc
        push ax

        mov ah, 01h
        int 16h
        jz revisar_flag

        mov ah, 00h
        int 16h
        cmp al, 27
        jne marcar_salto
        mov salir, 1
        jmp fin_teclado

        marcar_salto:
            mov flag_salto, 1

        revisar_flag:
            cmp flag_salto, 1
            jne fin_teclado

            mov flag_salto, 0
            mov salto, 2

        fin_teclado:
        pop ax
        ret
    teclado endp

    parte_logica proc
        push ax
        push cx

        inc bx 

        cmp salto, 0
        jle gravedad
        dec pajaro_y
        dec salto
        jmp limitar_pajaro

        gravedad:
            inc pajaro_y

        limitar_pajaro:
            cmp pajaro_y, 0
            jge techo_ok
            mov pajaro_y, 0
        techo_ok:

            dec tubo1_x
            mov ax, tubo1_x
            add ax, ancho_tubo
            cmp ax, 0
            jg puntos_t1
            mov tubo1_x, 79
            mov tubo1_pasado, 0
            mov tubo1_hueco_y, 5

        puntos_t1:
            cmp tubo1_pasado, 0
            jne mover_t2
            mov ax, tubo1_x
            add ax, ancho_tubo
            cmp ax, pajaro_x
            jge mover_t2
            mov tubo1_pasado, 1
            inc puntos

        mover_t2:
            dec tubo2_x
            mov ax, tubo2_x
            add ax, ancho_tubo
            cmp ax, 0
            jg puntos_t2
            mov tubo2_x, 79
            mov tubo2_pasado, 0
            mov tubo2_hueco_y, 10

        puntos_t2:
            cmp tubo2_pasado, 0
            jne revisar_choque
            mov ax, tubo2_x
            add ax, ancho_tubo
            cmp ax, pajaro_x
            jge revisar_choque
            mov tubo2_pasado, 1
            inc puntos


        revisar_choque:
            mov dx, 0


            mov ax, pajaro_y
            cmp ax, suelo_y
            jge hay_choque


            mov ax, pajaro_x
            cmp ax, tubo1_x
            jl revisar_tubo2
            mov cx, tubo1_x
            add cx, ancho_tubo
            cmp ax, cx
            jge revisar_tubo2

            mov ax, pajaro_y
            cmp ax, tubo1_hueco_y
            jl hay_choque
            mov cx, tubo1_hueco_y
            add cx, alto_hueco
            cmp ax, cx
            jge hay_choque

        revisar_tubo2:
            mov ax, pajaro_x
            cmp ax, tubo2_x
            jl fin_logica
            mov cx, tubo2_x
            add cx, ancho_tubo
            cmp ax, cx
            jge fin_logica

            mov ax, pajaro_y
            cmp ax, tubo2_hueco_y
            jl hay_choque
            mov cx, tubo2_hueco_y
            add cx, alto_hueco
            cmp ax, cx
            jge hay_choque
            jmp fin_logica

        hay_choque:
            mov dx, 1

        fin_logica:
        pop cx
        pop ax
        ret
    parte_logica endp

    parte_grafica proc
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        call limpiar_pantalla


        mov cx, 0
        mov dx, suelo_y
        mov al, char_suelo
        mov ah, attr_suelo
        dib_suelo:
            cmp cx, 80
            jge fin_dib_suelo
            call poner_celda
            inc cx
            jmp dib_suelo
        fin_dib_suelo:

        mov si, tubo1_x
        mov di, tubo1_hueco_y
        call dibujar_tubo_col

        mov si, tubo2_x
        mov di, tubo2_hueco_y
        call dibujar_tubo_col

        mov cx, pajaro_x
        mov dx, pajaro_y
        mov al, char_pajaro
        mov ah, attr_pajaro
        call poner_celda

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    parte_grafica endp

    pantalla_final proc
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        call limpiar_pantalla

        mov ah, 0Ch
        mov si, offset texto_perdiste
        mov bx, 35
        mov cx, 8
        call poner_texto

        mov ah, 0Fh
        mov si, offset texto_puntos
        mov bx, 32
        mov cx, 10
        call poner_texto

        mov ax, puntos
        mov di, offset numero
        call numero_a_texto
        mov byte ptr [di], 0
        mov ah, 0Fh
        mov si, offset numero
        mov bx, 40
        mov cx, 10
        call poner_texto

        mov ah, 07h
        mov si, offset texto_reintentar
        mov bx, 30
        mov cx, 13
        call poner_texto

        mov si, offset texto_salir
        mov bx, 30
        mov cx, 14
        call poner_texto

        call vaciar_teclado

    esperar_opcion:
        mov ah, 0
        int 16h
        cmp al, ' '
        je reintentar
        cmp al, 27
        jne esperar_opcion
        mov salir, 1
        jmp fin_final

    reintentar:
        mov salir, 0

    fin_final:
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    pantalla_final endp

    poner_texto proc
        push ax
        push bx
        push cx
        push dx
        push si

        mov dx, cx
        mov cx, bx
        mov bh, ah

    bucle_texto:
        mov al, [si]
        cmp al, 0
        je fin_texto
        mov ah, bh
        call poner_celda
        inc si
        inc cx
        jmp bucle_texto

    fin_texto:
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    poner_texto endp

    numero_a_texto proc
        push ax
        push bx
        push cx
        push dx

        mov bx, 10
        xor cx, cx

    dividir_num:
        xor dx, dx
        div bx
        add dl, '0'
        push dx
        inc cx
        test ax, ax
        jnz dividir_num

    escribir_digitos:
        pop dx
        mov [di], dl
        inc di
        loop escribir_digitos

        pop dx
        pop cx
        pop bx
        pop ax
        ret
    numero_a_texto endp

    vaciar_teclado proc
        push ax

    bucle_vaciar:
        mov ah, 01h
        int 16h
        jz fin_vaciar
        mov ah, 00h
        int 16h
        jmp bucle_vaciar

    fin_vaciar:
        pop ax
        ret
    vaciar_teclado endp

    dibujar_tubo_col proc
        push ax
        push bx
        push cx
        push dx
        push si

        mov dx, 0
        fila_tubo:
            cmp dx, suelo_y
            jge fin_tubo_col

            cmp dx, di
            jl es_pared_tubo
            mov ax, di
            add ax, alto_hueco
            cmp dx, ax
            jl sig_fila_tubo

        es_pared_tubo:
            mov cx, si
            mov bx, si
            add bx, ancho_tubo
            mov al, char_tubo
            mov ah, attr_tubo

        bucle_col_tubo:
            cmp cx, bx
            jge sig_fila_tubo
            call poner_celda
            inc cx
            jmp bucle_col_tubo

        sig_fila_tubo:
            inc dx
            jmp fila_tubo

        fin_tubo_col:
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
    dibujar_tubo_col endp

    poner_celda proc
        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push dx
        push di

        cmp cx, 0
        jl fin_celda
        cmp cx, 80
        jge fin_celda
        cmp dx, 0
        jl fin_celda
        cmp dx, 25
        jge fin_celda

        mov bx, ax
        mov ax, dx
        mov cx, 80
        mul cx 
        add ax, [bp-6]
        shl ax, 1 
        mov di, ax

        mov ax, bx
        mov es:[di], al
        mov es:[di+1], ah

        fin_celda:
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret
    poner_celda endp

    limpiar_pantalla proc
        push ax
        push cx
        push di

        mov di, 0
        mov cx, 80 * 25
        mov al, ' '
        mov ah, attr_vacio

        bucle_limpiar:
            mov es:[di], al
            mov es:[di+1], ah
            add di, 2
            loop bucle_limpiar

        pop di
        pop cx
        pop ax
        ret
    limpiar_pantalla endp

    esperar_paso proc
        push ax
        push bx
        push cx
        push dx

        mov ah, 00h
        int 1ah
        mov bx, dx

        esperar_tick:
            mov ah, 00h
            int 1ah
            cmp dx, bx
            je esperar_tick

        pop dx
        pop cx
        pop bx
        pop ax
        ret
    esperar_paso endp
end