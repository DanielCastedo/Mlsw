## Deploy en Render (Docker) - Guía rápida

1) Requisitos previos
- Tener el repo en GitHub (ya subido a `main`).
- Tener las URLs públicas o pre-signed de los assets: `modelo_precio.pkl`, `modelo_popularidad.pkl`, `productos_popularidad.csv`.

2) Variables de entorno necesarias (configurar en Render Dashboard -> Environment)
- `MODEL_PRECIO_URL` = URL al `modelo_precio.pkl`
- `MODEL_POP_URL` = URL al `modelo_popularidad.pkl`
- `PRODUCTOS_CSV_URL` = URL al `productos_popularidad.csv`
- (opcional) `MODEL_TF_URL` = URL al zip/tar/.h5/.keras del modelo TF
- `FLASK_DEBUG` = `0` (producción) o `1` (debug)

3) Pasos en Render (panel web)
- New -> Web Service -> Connect repo -> seleccionar `DanielCastedo/Mlsw` -> Branch `main`.
- Environment: elegir `Docker`.
- En Environment -> Add Environment Variable agregar las variables anteriores (marcar como Secret si aplica).
- Crear servicio. Render hará build usando `Dockerfile` y ejecutará `start.sh`.

4) Comprobaciones
- Logs de build: ver si `pip install` finaliza sin errores.
- Logs de runtime: buscar `Starting gunicorn` y luego `Worker boot` o `health` checks.
- Endpoints: `/health`, `/predecir` y `/popularidad`.

5) Notas sobre TensorFlow
- Por defecto `requirements.txt` NO instala `tensorflow` para acelerar builds.
- Si necesitás TF en Render, añade `tensorflow==2.20.0` a `requirements.txt` y considera usar un plan con más recursos o una imagen base que ya incluya TF.

6) Quitar assets del repo (si es necesario)
- Ya removimos los modelos grandes del índice y están en `.gitignore`.

7) Problemas comunes
- Error `Worker failed to boot`: revisar errores de sintaxis en `app.py` o excepciones al importar (ya corregido).
- Errores de pip: ajustar versiones en `requirements.txt`.

Si querés, puedo:
- Generar pre-signed URLs para S3 y subir los modelos por vos (necesitaría credenciales temporales).
- Añadir `tensorflow` y preparar una imagen separada (para producción TF-heavy).
- Ejecutar una build local y compartir logs completos.
