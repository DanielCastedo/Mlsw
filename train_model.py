import pandas as pd
from sklearn.linear_model import LinearRegression
import joblib

# Datos de ejemplo (luego se conectará a tu BD Laravel)
data = {
    "categoria": [1, 1, 2, 2, 3, 3],
    "stock":     [10, 20, 5, 15, 30, 8],
    "precio":    [50, 45, 60, 55, 40, 48],
}

df = pd.DataFrame(data)

X = df[["categoria", "stock"]]
y = df["precio"]

model = LinearRegression()
model.fit(X, y)

joblib.dump(model, "modelo_precio.pkl")

print("Modelo entrenado y guardado como modelo_precio.pkl")
