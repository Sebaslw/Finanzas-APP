# Finanzas: app de finanzas personales

## Ejecutar en localhost (Windows)
1. Descomprime la carpeta `finanzas` (no la abras desde dentro del ZIP).
2. Haz doble clic en **`iniciar.bat`**.
3. Se abre una ventana negra (CMD) y el navegador en **http://localhost:8080**.
4. Para detenerlo: `Ctrl+C` en la ventana o ciérrala.

No necesitas instalar nada: usa PowerShell, que viene con Windows 10 y 11.
Si el puerto 8080 está ocupado, usa el siguiente libre (8081, 8082...) y lo muestra en la ventana.

También puedes iniciarlo escribiendo en CMD, dentro de la carpeta:

    iniciar.bat

En Mac o Linux: `sh iniciar.sh` (requiere Python 3).

## Primer uso
La app empieza vacía: escribe tu nombre y registra tus movimientos.
Si prefieres verla primero con ejemplos, elige "Ver con datos de ejemplo"; luego puedes borrarlos con "Empezar con mis datos".

## Dónde se guardan los datos
En el navegador (localStorage), separados por dirección. Lo que registres en
http://localhost:8080 solo aparece en esa misma dirección y navegador.
Usa siempre el mismo puerto y exporta a Excel o CSV de vez en cuando como respaldo.

Necesita internet para cargar React, la tipografía y las librerías de Excel y PDF.

## Archivos
- `index.html`: la aplicación completa
- `iniciar.bat`: arranca el servidor local en Windows
- `servidor.ps1`: el servidor (lo usa iniciar.bat)
- `iniciar.sh`: arranque para Mac/Linux
