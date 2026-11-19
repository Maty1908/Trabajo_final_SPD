# 🐤 Flappy Bird ASCII — `Trabajo_final_SPD`

**Un Flappy Bird diseñado íntegramente con caracteres tipográficos y letras en estilo consola retro.**

*Sin gráficos vectoriales ni texturas: solo código ASCII en movimiento sobre fondo oscuro.*

## 📖 Sobre el Proyecto

`Trabajo_final_SPD` es una recreación de **Flappy Bird** desarrollada en ensamblador **x86 (16 bits)** para la materia **Sistemas de Procesamiento de Datos (SPD)**.

Todo el entorno visual se construye escribiendo caracteres y atributos de color directamente en la memoria de video (`0B800h`) en modo texto (`80x25`), logrando una estética de consola retro puramente tipográfica sobre fondo oscuro:

```text
  +--------------------------------------------------------------------------------+
  |                                              ###                        ###    |
  |                                              ###                        ###    |
  |                                              ###                        ###    |
  |              >                                                          ###    |
  |                                              ###                               |
  |                                              ###                        ###    |
  |================================================================================|
  +--------------------------------------------------------------------------------+
```

## ✨ Características Principales

* **Renderizado Directo en `0B800h`:** Dibujo celda por celda en modo texto `80x25` sin librerías gráficas externas.
* **Arquitectura con Interrupciones Residentes (TSR):** Manejo de eventos mediante rutinas residentes en memoria (`.model tiny` / `.COM`) y efectos de sonido por PC Speaker (`INT 81h`).
* * **Física y Colisiones:** Gravedad sincronizada con ticks de BIOS (`INT 1Ah`), impulso de salto, límites de pantalla y detección de choque contra tubos y suelo.
* **Historial Persistente (`his.txt`):** Lectura y actualización del top de puntajes en disco mediante servicios de archivos de DOS (`INT 21h`).
* **Pantalla Final:** Muestra el puntaje obtenido al perder y permite reintentar (`ESPACIO`) o volver al menú (`ESC`).

## 🎮 Controles

* **Cualquier tecla:** Impulsar el pájaro (`>`) hacia arriba.
* **`ESPACIO` (en pantalla final):** Reintentar la partida.
* **`ESC`:** Salir de la partida o volver al menú.
