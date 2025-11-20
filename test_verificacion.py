"""
Script de verificacion rapida
Verifica que los modelos se cargan correctamente
"""
import joblib
import numpy as np
import pandas as pd

print("Verificando archivos...")

# Verificar modelo de precios
try:
    print("\n1. Cargando modelo_precio.pkl...")
    model_precio = joblib.load("modelo_precio.pkl")
    print("   [OK] Modelo de precios cargado correctamente")
    
    # Probar prediccion
    test_input = np.array([[2, 15]])
    pred = model_precio.predict(test_input)
    print(f"   [OK] Prediccion de prueba: {pred[0]:.2f}")
except Exception as e:
    print(f"   [ERROR] {e}")

# Verificar modelo de popularidad
try:
    print("\n2. Cargando modelo_popularidad.pkl...")
    model_popularidad = joblib.load("modelo_popularidad.pkl")
    print("   [OK] Modelo de popularidad cargado correctamente")
except Exception as e:
    print(f"   [ERROR] {e}")

# Verificar CSV
try:
    print("\n3. Cargando productos_popularidad.csv...")
    df = pd.read_csv("productos_popularidad.csv")
    print(f"   [OK] CSV cargado: {len(df)} productos")
    print(f"   Productos: {', '.join(df['nombre'].astype(str))}")
except Exception as e:
    print(f"   [ERROR] {e}")

# Verificar Flask
try:
    print("\n4. Verificando Flask...")
    from flask import Flask
    app = Flask(__name__)
    print("   [OK] Flask importado correctamente")
except Exception as e:
    print(f"   [ERROR] {e}")

print("\n" + "="*50)
print("[OK] VERIFICACION COMPLETA")
print("="*50)
print("\nSi todos los pasos tienen [OK], puedes ejecutar app.py")
print("Comando: python app.py")

