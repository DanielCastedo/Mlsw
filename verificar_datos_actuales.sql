-- SCRIPT PARA VERIFICAR DATOS ACTUALES
-- Ejecuta esto en pgAdmin para ver que tienes

-- 1. Ver cuantas categorias tienes
SELECT COUNT(*) as total_categorias FROM categorias;
SELECT * FROM categorias;

-- 2. Ver cuantos productos tienes
SELECT COUNT(*) as total_productos FROM productos;
SELECT p.id, p.nombre, c.nombre as categoria 
FROM productos p 
JOIN categorias c ON p.categoria_id = c.id;

-- 3. Ver cuantas tiendas tienes
SELECT COUNT(*) as total_tiendas FROM tiendas;
SELECT id, nombre, direccion FROM tiendas;

-- 4. Ver relaciones producto-tienda (LO MAS IMPORTANTE)
SELECT COUNT(*) as total_relaciones FROM tienda_producto;
SELECT 
    tp.id,
    t.nombre as tienda,
    p.nombre as producto,
    tp.precio,
    tp.stock
FROM tienda_producto tp
JOIN tiendas t ON tp.tienda_id = t.id
JOIN productos p ON tp.producto_id = p.id
ORDER BY p.nombre;

