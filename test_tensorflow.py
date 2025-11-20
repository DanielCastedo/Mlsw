"""
Script para probar el endpoint TensorFlow
Simula una peticion desde Laravel
"""
import requests
import json

# URL del servidor Flask
BASE_URL = "http://localhost:5000"

print("="*60)
print("PRUEBA DE TENSORFLOW - ENDPOINT /predecir-tf")
print("="*60)

# Datos de prueba (simulando lo que enviaria Laravel)
datos_prueba = {
    "categoria_id": 1,      # Verduras
    "stock": 20,
    "latitud": -17.854669,
    "longitud": -63.24977,
    "popularidad": 2        # 2 tiendas venden este producto
}

print("\n1. Datos que enviaremos:")
print(json.dumps(datos_prueba, indent=2))

print("\n2. Haciendo peticion a Flask...")
try:
    response = requests.post(
        f"{BASE_URL}/predecir-tf",
        json=datos_prueba,
        headers={"Content-Type": "application/json"}
    )
    
    print(f"\n3. Respuesta del servidor:")
    print(f"   Status Code: {response.status_code}")
    
    if response.status_code == 200:
        resultado = response.json()
        print(f"\n   ✅ EXITO!")
        print(f"   Precio predicho: ${resultado['precio_predicho']}")
        print(f"   Modelo usado: {resultado['modelo']}")
        print(f"\n   Detalles:")
        print(f"   - Categoria: {resultado['categoria_id']}")
        print(f"   - Stock: {resultado['stock']}")
        print(f"   - Popularidad: {resultado['popularidad']}")
    else:
        print(f"\n   ❌ ERROR:")
        print(f"   {response.text}")
        
except requests.exceptions.ConnectionError:
    print("\n   ❌ ERROR: No se puede conectar a Flask")
    print("   Asegurate de que Flask este corriendo:")
    print("   python app.py")
except Exception as e:
    print(f"\n   ❌ ERROR: {e}")

print("\n" + "="*60)

