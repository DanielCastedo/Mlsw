from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import numpy as np
import pandas as pd
import os

app = Flask(__name__)
CORS(app)  # Permitir CORS para Laravel

# Modelo de precios (sklearn)
model_precio = joblib.load("modelo_precio.pkl")

# Modelo de popularidad (sklearn)
model_popularidad = joblib.load("modelo_popularidad.pkl")
df = pd.read_csv("productos_popularidad.csv")

# Modelo TensorFlow (NUEVO) - carga perezosa
# No importamos TensorFlow en el arranque para evitar bloqueos en entornos
# donde la importación puede fallar o tardar mucho. Se cargará al primer
# llamado al endpoint `/predecir-tf`.
tf_disponible = False
model_tf = None
scaler_X_tf = None
scaler_y_tf = None

# =====================
# ENDPOINT 1: PRECIOS
# =====================
@app.route("/predecir", methods=["POST"])
def predecir():
    data = request.json
    categoria = data["categoria"]
    stock = data["stock"]
    entrada = np.array([[categoria, stock]])
    pred = model_precio.predict(entrada)
    return jsonify({"precio_sugerido": float(pred[0])})


# ===========================
# ENDPOINT 2: POPULARIDAD
# ===========================
@app.route("/popularidad", methods=["POST"])
def popularidad():
    data = request.json
    producto_id = data["producto_id"]

    row = df[df["producto_id"] == producto_id]
    if row.empty:
        return jsonify({"error": "Producto no encontrado"}), 404

    index = row.index.values[0]
    pred = model_popularidad.predict([[index]])

    return jsonify({
        "producto_id": int(producto_id),
        "nombre": row.iloc[0]["nombre"],
        "popularidad_actual": int(row.iloc[0]["tiendas_que_lo_venden"]),
        "popularidad_predicha": float(pred[0])
    })


# ===========================
# ENDPOINT 3: PRECIOS CON TENSORFLOW (NUEVO)
# ===========================
@app.route("/predecir-tf", methods=["POST"])
def predecir_tf():
    # Cargar el modelo TensorFlow bajo demanda la primera vez que se solicita
    global tf_disponible, model_tf, scaler_X_tf, scaler_y_tf
    if model_tf is None:
        try:
            import tensorflow as tf
            # Intentar cargar en formato .keras primero, luego .h5
            if os.path.exists('modelo_precio_tf/modelo.keras'):
                model_tf = tf.keras.models.load_model('modelo_precio_tf/modelo.keras')
            elif os.path.exists('modelo_precio_tf/modelo.h5'):
                model_tf = tf.keras.models.load_model('modelo_precio_tf/modelo.h5', compile=False)
                model_tf.compile(optimizer='adam', loss='mse', metrics=['mae'])
            else:
                return jsonify({"success": False, "error": "No se encontró el modelo TensorFlow"}), 503

            scaler_X_tf = joblib.load('modelo_precio_tf/scaler_X.pkl')
            scaler_y_tf = joblib.load('modelo_precio_tf/scaler_y.pkl')
            tf_disponible = True
            print("✅ Modelo TensorFlow cargado correctamente (on-demand)")
        except Exception as e:
            tf_disponible = False
            return jsonify({"success": False, "error": f"TensorFlow no disponible: {e}"}), 503

    try:
        data = request.json
        
        # Validar datos requeridos
        categoria_id = int(data.get('categoria_id', 0))
        stock = float(data.get('stock', 0))
        latitud = float(data.get('latitud', 0))
        longitud = float(data.get('longitud', 0))
        popularidad = int(data.get('popularidad', 0))
        
        # Preparar entrada
        entrada = np.array([[categoria_id, stock, latitud, longitud, popularidad]])
        entrada_scaled = scaler_X_tf.transform(entrada)
        
        # Predecir con TensorFlow
        pred_scaled = model_tf.predict(entrada_scaled, verbose=0)
        precio_predicho = scaler_y_tf.inverse_transform(pred_scaled)[0][0]
        
        return jsonify({
            "success": True,
            "precio_predicho": round(float(precio_predicho), 2),
            "modelo": "TensorFlow",
            "categoria_id": categoria_id,
            "stock": stock,
            "popularidad": popularidad
        })
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 400


# ===========================
# ENDPOINT DE SALUD (para verificar que Flask funciona)
# ===========================
@app.route("/health", methods=["GET"])
def health():
    return jsonify({
        "status": "ok",
        "tensorflow": tf_disponible,
        "sklearn": True
    })


# Ejecutar todo en el mismo servidor
if __name__ == "__main__":
    # Ejecutar usando variables de entorno para compatibilidad con Docker/Render
    host = os.environ.get('HOST', '0.0.0.0')
    port = int(os.environ.get('PORT', 5000))
    debug = os.environ.get('FLASK_DEBUG', '0') == '1'
    app.run(host=host, port=port, debug=debug, use_reloader=False)
