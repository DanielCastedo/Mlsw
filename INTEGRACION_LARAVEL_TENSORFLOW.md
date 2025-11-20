# INTEGRACION TENSORFLOW CON LARAVEL

## ARQUITECTURA DEL SISTEMA:

```
┌─────────────┐         ┌──────────────┐         ┌─────────────┐
│   Laravel   │  HTTP   │ Flask (ML)   │  Python │ TensorFlow  │
│  (Backend)  │ ──────> │  (Servicio)  │ ──────> │  (Modelo)   │
│  Puerto 8000│         │ Puerto 5000  │         │             │
└─────────────┘         └──────────────┘         └─────────────┘
     │                          │
     │                          │
     v                          v
┌─────────────┐         ┌──────────────┐
│ PostgreSQL  │         │   Modelos    │
│  (Datos)    │         │   .h5, .pkl  │
└─────────────┘         └──────────────┘
```

## FLUJO DE INTEGRACION:

### 1. USUARIO EN LARAVEL (Web):
- Usuario quiere agregar un producto a su tienda
- Necesita un precio sugerido

### 2. LARAVEL LLAMA A FLASK:
- Laravel hace peticion HTTP a Flask (puerto 5000)
- Envia: categoria_id, stock, latitud, longitud, popularidad

### 3. FLASK USA TENSORFLOW:
- Flask recibe los datos
- Los normaliza
- Pasa al modelo TensorFlow
- Obtiene prediccion de precio

### 4. FLASK RESPONDE A LARAVEL:
- Retorna precio predicho
- Laravel muestra al usuario

### 5. LARAVEL MUESTRA AL USUARIO:
- Precio sugerido por Machine Learning
- Usuario puede aceptar o modificar

## VENTAJAS DE ESTA ARQUITECTURA:

✅ **Separacion de responsabilidades**: Laravel maneja web, Flask maneja ML
✅ **Escalable**: Puedes tener multiples instancias de Flask
✅ **Mantenible**: Cambios en ML no afectan Laravel
✅ **Reutilizable**: Flutter tambien puede usar Flask directamente

