Despliegue en Render usando Docker

Pasos básicos:

1) Asegúrate de que el repositorio contenga el `Dockerfile` (ya incluido).

2) Añade las variables de entorno en Render (Settings -> Environment -> Environment Variables):
   - `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD` (o las que uses en `.env`)
   - `PORT` no es necesario establecer manualmente; Render la proporciona al contenedor. Puedes dejar `PORT` vacío.
   - `FLASK_DEBUG` = `0` (para producción)

3) Crear servicio en Render:
   - Tipo: "Web Service"
   - Opciones: "Docker" (Render detectará `Dockerfile` y construirá la imagen)
   - Si quieres, puedes conectar el repositorio Git; Render construirá automáticamente en cada push.

4) Tamaño de la imagen y TensorFlow:
   - TensorFlow aumenta mucho el tamaño de la imagen (>=1GB). Si no necesitas TF en Render (por ejemplo, sólo usas modelos sklearn), considera excluir `tensorflow` de `requirements.txt` y/o usar un servicio separado para modelos TF.
   - Si necesitas TensorFlow en el contenedor, la imagen proporcionada aquí instala `tensorflow==2.20.0` desde wheels.

5) Probar localmente (opcional):

   - Construir la imagen:
     docker build -t miapp:latest .

   - Ejecutar:
     docker run -e PORT=5000 -p 5000:5000 miapp:latest

   - Probar en Postman: GET http://localhost:5000/health

6) Notas adicionales:
   - Si los modelos (`modelo_precio.pkl`, `modelo_popularidad.pkl`, `modelo_precio_tf/*`) son muy grandes, es mejor colocarlos en un almacenamiento externo (S3, Render Disk, etc.) y descargarlos al iniciar el contenedor.
   - Recomendación: usar un servicio de CI/CD para construir y empujar la imagen a un registry si prefieres no usar construcción directa desde el repo.
