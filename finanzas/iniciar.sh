#!/bin/sh
# Mac / Linux: servidor local con Python 3
cd "$(dirname "$0")"
echo "Finanzas corriendo en http://localhost:8080  (Ctrl+C para detener)"
( sleep 1; (open http://localhost:8080 2>/dev/null || xdg-open http://localhost:8080 2>/dev/null) ) &
python3 -m http.server 8080
