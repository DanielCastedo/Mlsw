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
    && rm -rf /var/lib/apt/lists/*

# Copiar requirements e instalar
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copiar el resto del proyecto
COPY . /app

# Puerto por defecto
EXPOSE 5000

# Comando de arranque: usar gunicorn (expande ${PORT} en shell)
CMD ["sh", "-c", "gunicorn app:app --bind 0.0.0.0:${PORT:-5000} --workers 2 --threads 2"]
