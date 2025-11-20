import pandas as pd
from sqlalchemy import create_engine
from sklearn.linear_model import LinearRegression
import joblib
import numpy as np

# ==========================
# 1. CONEXIÓN A LA BD POSTGRESQL
# ==========================
# Usando SQLAlchemy para PostgreSQL (más compatible con pandas)
# Formato: postgresql://usuario:contraseña@host:puerto/nombre_bd
# Si tu base de datos tiene otro nombre, cambia "preciosw2" por el nombre correcto
conn_string = "postgresql://postgres:postgres@localhost:5432/PrecioSw2"
engine = create_engine(conn_string)
conn = engine.connect()

# ==========================
# 2. CONSULTA REAL
# ==========================
query = """
SELECT 
    p.id AS producto_id,
    p.nombre,
    COUNT(tp.id) AS tiendas_que_lo_venden
FROM tienda_producto tp
JOIN productos p ON tp.producto_id = p.id
GROUP BY p.id;
"""

df = pd.read_sql(query, conn)
conn.close()
engine.dispose()

print("\nDatos extraídos:")
print(df)

# ==========================
# 3. PREPARAR DATOS
# ==========================
X = np.array(df.index).reshape(-1, 1)   # índice como feature
y = df["tiendas_que_lo_venden"]         # popularidad real

# ==========================
# 4. ENTRENAR MODELO
# ==========================
model = LinearRegression()
model.fit(X, y)

# ==========================
# 5. GUARDAR EL MODELO
# ==========================
joblib.dump(model, "modelo_popularidad.pkl")
df.to_csv("productos_popularidad.csv", index=False)

print("\n✅ Modelo de popularidad entrenado")
print("Archivo generado: modelo_popularidad.pkl")
print("Datos guardados: productos_popularidad.csv")
