#!/bin/sh
set -e

echo "[start.sh] Iniciando tareas previas al arranque..."

cd /app

# Helper para descargar con curl
download() {
  url="$1"
  dest="$2"
  if [ -z "$url" ]; then
    return 0
  fi
  echo "[start.sh] Descargando $url -> $dest"
  curl -sSL "$url" -o "$dest"
}

# Descargar modelos si no existen y si se proporcionó URL
if [ ! -f "modelo_precio.pkl" ] && [ ! -z "$MODEL_PRECIO_URL" ]; then
  download "$MODEL_PRECIO_URL" "modelo_precio.pkl"
fi

if [ ! -f "modelo_popularidad.pkl" ] && [ ! -z "$MODEL_POP_URL" ]; then
  download "$MODEL_POP_URL" "modelo_popularidad.pkl"
fi

if [ ! -f "productos_popularidad.csv" ] && [ ! -z "$PRODUCTOS_CSV_URL" ]; then
  download "$PRODUCTOS_CSV_URL" "productos_popularidad.csv"
fi

# Modelo TensorFlow: si se pasa una URL puede ser zip/tar.gz o un único .h5/.keras
if [ ! -d "modelo_precio_tf" ] || [ -z "$(ls -A modelo_precio_tf 2>/dev/null)" ]; then
  if [ ! -z "$MODEL_TF_URL" ]; then
    mkdir -p modelo_precio_tf
    tmpfile="/tmp/tf_model_asset"
    download "$MODEL_TF_URL" "$tmpfile"
    # Detectar tipo
    case "$MODEL_TF_URL" in
      *.zip)
        echo "[start.sh] Extrayendo zip de TensorFlow..."
        unzip -o "$tmpfile" -d modelo_precio_tf >/dev/null
        ;;
      *.tar.gz|*.tgz)
        echo "[start.sh] Extrayendo tar.gz de TensorFlow..."
        tar -xzf "$tmpfile" -C modelo_precio_tf
        ;;
      *.h5|*.keras)
        echo "[start.sh] Moviendo archivo TF (.h5/.keras) a carpeta modelo_precio_tf..."
        mv "$tmpfile" "modelo_precio_tf/$(basename "$MODEL_TF_URL")"
        ;;
      *)
        echo "[start.sh] Tipo desconocido, guardando archivo en modelo_precio_tf/asset"
        mv "$tmpfile" modelo_precio_tf/asset
        ;;
    esac
  fi
fi

echo "[start.sh] Recursos preparados. Lanzando gunicorn..."

# Ejecutar gunicorn con la variable PORT proporcionada por Render
exec gunicorn app:app --bind 0.0.0.0:${PORT:-5000} --workers 2 --threads 2
