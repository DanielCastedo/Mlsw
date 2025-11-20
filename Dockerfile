# Dockerfile para desplegar en Render (o cualquier proveedor que use Docker)
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

# Dependencias del sistema (psycopg2 y compilación de paquetes si fuera necesario)
RUN apt-get update \
     && apt-get install -y --no-install-recommends \
         build-essential \
         libpq-dev \
         curl \
         unzip \
     && rm -rf /var/lib/apt/lists/*

# Copiar requirements e instalar
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copiar el resto del proyecto
COPY . /app

# Copiar script de arranque que descargará modelos si es necesario
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Puerto por defecto
EXPOSE 5000

# Ejecutar script de arranque (descarga assets y lanza gunicorn)
CMD ["sh", "/app/start.sh"]
