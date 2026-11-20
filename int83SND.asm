.8086
.model tiny
.code
  org 100h

  start:  ;──────────────────────────────
    jmp main                            ;| Punto de entrada del programa .COM. Salta por encima de la rutina
                                        ;| residente hasta main, que es el código de instalación.
          ;──────────────────────────────

  Funcion PROC FAR

    ;──────────────────────────────
    sti                           ;| Rutina de atención de la INT 83h (la parte que queda residente).
    pushf                         ;| Habilita interrupciones y guarda el contexto (banderas y registros).
    push ax                       ;| Carga DX con 16000, el valor inicial del barrido de frecuencia.
    push bx                       ;|
    push cx                       ;|
    push dx                       ;|
                                  ;|
    mov dx, 16000                 ;|
          ;──────────────────────────────

    play: ;──────────────────────────────
      mov bx, 1                         ;| Genera un tono: carga DX como divisor del canal 2 del temporizador
                                        ;| (puerto 42h, primero el byte bajo y luego el alto) y enciende el
      mov ax, dx                        ;| parlante poniendo los bits 0 y 1 del puerto 61h en 1.
      out 42h, al                       ;|
      mov al, ah                        ;|
      out 42h, al                       ;|
                                        ;|
      in al, 61h                        ;|
      or al, 00000011b                  ;|
      out 61h, al                       ;|
          ;──────────────────────────────

    pause1: ;──────────────────────────────
      push dx                             ;| Pausa: deja sonando la nota mientras se ejecutan los bucles de espera.
      mov cx, 100                         ;|
          ;──────────────────────────────

    pause2: ;──────────────────────────────
      dec cx                              ;| Bucle de espera interno (CX) y externo (BX). Al terminar recupera DX.
      jnz pause2                          ;|
      dec bx                              ;|
      jnz pause1                          ;|
      pop dx                              ;|
          ;──────────────────────────────

    ;──────────────────────────────
      in al, 61h                  ;| Apaga el parlante (bits 0 y 1 del puerto 61h en 0), baja DX y repite
      and al, 11111100b           ;| play hasta que DX llegue a 0. Así se produce un barrido de tonos.
      out 61h, al                 ;|
                                  ;|
      dec dx                      ;|
      jnz play                    ;|
          ;────────────────────────

    ;──────────────────────────────
      pop dx                      ;| Fin de la rutina: restaura el contexto y devuelve el control con IRET.
      pop cx                      ;|
      pop bx                      ;|
      pop ax                      ;|
      popf                        ;|
      iret                        ;|
          ;────────────────────────

  endp

  ;──────────────────────────────
  DespIntXX dw 0                ;| Guardan la dirección (desplazamiento y segmento) del vector 83h original.
  SegIntXX  dw 0                ;|
          ;──────────────────────
          ;──────────────────────────────
  FinResidente LABEL BYTE               ;| Marca el final de la parte residente, se usa para calcular la memoria a reservar.
          ;──────────────────────────────

                                    ;──────────────────────────────
  Cartel    DB "Programa Instalado exitosamente!!!",0dh, 0ah, '$' ;| Mensaje que se muestra al terminar la instalación.
                                    ;──────────────────────────────

  main:
                  ;──────────────────────────────
    mov ax,CS                                   ;| Código de instalación: iguala DS y ES con CS (modelo tiny).
    mov DS,ax                                   ;|
    mov ES,ax                                   ;|
                  ;──────────────────────────────

    InstalarInt:    ;──────────────────────────────
      mov AX,3583h                                ;| Guarda el vector original del tipo 83h (función 35h del INT 21h)
      int 21h                                     ;| y lo reemplaza por la dirección de Funcion (función 25h).
                                                  ;| Desde ahora, un INT 83h ejecuta la rutina de sonido.
      mov DespIntXX,BX                            ;|
      mov SegIntXX,ES                             ;|
                                                  ;|
      mov AX,2583h                                ;|
      mov DX,Offset Funcion                       ;|
      int 21h                                     ;|
          ;────────────────────────────────────────

    MostrarCartel:  ;──────────────────────────────
      mov dx, offset Cartel                       ;| Imprime el mensaje de instalación exitosa (función 09h del INT 21h).
      mov ah,9                                    ;|
      int 21h                                     ;|
          ;────────────────────────────────────────

    DejarResidente:         ;──────────────────────────────
      Mov     AX,(15 + offset FinResidente)               ;| Calcula cuántos párrafos (16 bytes) quedan residentes: (tamaño + 15) / 16.
      Shr     AX,1                                        ;| Termina el programa dejando la rutina en memoria (función 31h del INT 21h).
      Shr     AX,1                                        ;|
      Shr     AX,1                                        ;|
      Shr     AX,1                                        ;|
      Mov     DX,AX                                       ;|
      Mov     AX,3100h                                    ;|
      Int     21h                                         ;|
                            ;──────────────────────────────

end start
