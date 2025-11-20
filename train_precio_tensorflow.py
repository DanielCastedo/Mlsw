"""
ENTRENAMIENTO DE MODELO TENSORFLOW PARA PREDICCION DE PRECIOS
Este script entrena una red neuronal simple para predecir precios de productos
"""
import pandas as pd
from sqlalchemy import create_engine
import numpy as np
import tensorflow as tf
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
import joblib
import os

print("="*60)
print("ENTRENAMIENTO DE MODELO TENSORFLOW PARA PRECIOS")
print("="*60)

# ==========================
# 1. CONEXION A LA BD POSTGRESQL
# ==========================
print("\n[1/6] Conectando a base de datos...")
conn_string = "postgresql://postgres:postgres@localhost:5432/PrecioSw2"
engine = create_engine(conn_string)
conn = engine.connect()

# ==========================
# 2. CONSULTA DE DATOS REALES
# ==========================
print("[2/6] Extrayendo datos de la base de datos...")
query = """
SELECT 
    tp.precio,
    tp.stock,
    p.categoria_id,
    t.latitud,
    t.longitud,
    (SELECT COUNT(*) 
     FROM tienda_producto tp2 
     WHERE tp2.producto_id = p.id) as popularidad
FROM tienda_producto tp
JOIN productos p ON tp.producto_id = p.id
JOIN tiendas t ON tp.tienda_id = t.id
WHERE tp.precio > 0 
  AND tp.stock >= 0
  AND t.latitud IS NOT NULL 
  AND t.longitud IS NOT NULL;
"""

df = pd.read_sql(query, conn)
conn.close()
engine.dispose()

print(f"   Datos cargados: {len(df)} registros")
print(f"   Muestra de datos:")
print(df.head())

# ==========================
# 3. PREPARAR DATOS
# ==========================
print("\n[3/6] Preparando datos para entrenamiento...")

# Features: categoria_id, stock, latitud, longitud, popularidad
X = df[['categoria_id', 'stock', 'latitud', 'longitud', 'popularidad']].values
y = df['precio'].values.reshape(-1, 1)

print(f"   Features (entrada): {X.shape}")
print(f"   Target (salida): {y.shape}")

# Normalizar features (importante para TensorFlow)
scaler_X = StandardScaler()
X_scaled = scaler_X.fit_transform(X)

scaler_y = StandardScaler()
y_scaled = scaler_y.fit_transform(y)

# Dividir datos en entrenamiento y prueba
X_train, X_test, y_train, y_test = train_test_split(
    X_scaled, y_scaled, test_size=0.2, random_state=42
)

print(f"   Datos de entrenamiento: {X_train.shape[0]} registros")
print(f"   Datos de prueba: {X_test.shape[0]} registros")

# ==========================
# 4. CREAR MODELO TENSORFLOW
# ==========================
print("\n[4/6] Creando modelo TensorFlow...")

# Red neuronal simple:
# - Capa 1: 8 neuronas (entrada)
# - Capa 2: 4 neuronas (oculta)
# - Capa 3: 1 neurona (salida: precio)
model = tf.keras.Sequential([
    tf.keras.layers.Dense(8, activation='relu', input_shape=(5,), name='capa_entrada'),
    tf.keras.layers.Dropout(0.2, name='dropout_1'),
    tf.keras.layers.Dense(4, activation='relu', name='capa_oculta'),
    tf.keras.layers.Dropout(0.2, name='dropout_2'),
    tf.keras.layers.Dense(1, name='capa_salida')
])

# Compilar modelo
model.compile(
    optimizer='adam',
    loss='mse',  # Error cuadratico medio
    metrics=['mae']  # Error absoluto medio
)

print("   Modelo creado:")
model.summary()

# ==========================
# 5. ENTRENAR MODELO
# ==========================
print("\n[5/6] Entrenando modelo...")
print("   Esto puede tardar unos segundos...")

history = model.fit(
    X_train, y_train,
    epochs=100,
    batch_size=16,
    validation_split=0.2,
    verbose=1
)

# ==========================
# 6. EVALUAR Y GUARDAR
# ==========================
print("\n[6/6] Evaluando y guardando modelo...")

# Evaluar en datos de prueba
test_loss, test_mae = model.evaluate(X_test, y_test, verbose=0)

# Convertir error normalizado a error real
error_real = scaler_y.inverse_transform([[test_mae]])[0][0]

print(f"\n   Error promedio (MAE): ${error_real:.2f}")

# Guardar modelo y scalers
os.makedirs('modelo_precio_tf', exist_ok=True)
# Guardar en formato .keras (más compatible con versiones nuevas)
model.save('modelo_precio_tf/modelo.keras')
# También guardar en formato SavedModel (alternativa)
# model.save('modelo_precio_tf/modelo_savedmodel')
joblib.dump(scaler_X, 'modelo_precio_tf/scaler_X.pkl')
joblib.dump(scaler_y, 'modelo_precio_tf/scaler_y.pkl')

print("\n" + "="*60)
print("MODELO TENSORFLOW ENTRENADO EXITOSAMENTE")
print("="*60)
print("\nArchivos generados:")
print("   - modelo_precio_tf/modelo.keras (red neuronal)")
print("   - modelo_precio_tf/scaler_X.pkl (normalizador entrada)")
print("   - modelo_precio_tf/scaler_y.pkl (normalizador salida)")
print(f"\nError promedio: ${error_real:.2f}")
print("\nEl modelo esta listo para usar!")

