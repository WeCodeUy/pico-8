# pico-8
Proyectos para curso de Pico-8
Se usa en: https://www.pico-8-edu.com/

## Comandos básicos 
Abrir editor: Tecla esc

Correr un proyecto: ctrl + r

Guardar un proyecto: 
- SAVE nombreProyecto: guarda proyecto en formato .p8
- SAVE nombreProyecto.p8.png: guarda el proyecto en png

Cargar un proyecto:
- Arrastrar archivo a la pantalla
- LOAD nombreProyecto

## Funciones predeterminadas del editor

### _init()

Esta función se ejecuta una sola vez al inicio del juego y se usa para inicializar variables, configurar el estado inicial y preparar el entorno.

### _update()

Se ejecuta 30 veces por segundo (por defecto) y maneja toda la lógica del juego. Ejemplo: 
- Movimiento de objetos.
- Control del jugador.
- Detección de colisiones.
- Cambios en el estado del juego.

### _draw() 

Se ejecuta 30 veces por segundo (después de _update) y se encarga de dibujar en la pantalla. Ejemplo:
- Dibuja sprites, formas, texto, y otros gráficos.
- Refleja el estado actual del juego.

## Proyectos armados
SquareRun: cuadrado que debe saltar (con la tecla n) para evitar obstáculos. (Básico)

Estrellas: cuadrado que debe atrapar las estrellas amarillas y evitar las rojas, moviendose con las flechas. (Básico)

Penales: al apretar la tecla n, se lanza una pelota uqe se deberá embocar al arco. Hay 5 intentos. (Básico)

Meteoritos: con la nave espacial, moviendola de lado a lado con las flechas, deben dispararle con la n a los meteoritos que caen por la pantalla para evitar perder. (Intermedio)

Laberinto: el personaje se mueve con las flechas por la pantalla, esquivando los cuadrados para llegar a la estrella, donde gana. Si toca un cuadrado pierde. (Intermedio)

Platformer: el personaje debe ir saltando de plataforma en plataforma, evitando caer al vacío, si no pierde. (Intermedio)

Pasajeros: el personaje, un auto, debe recoger a todos los pasajeros antes de que se acabe el tiempo. (Intermedio)
