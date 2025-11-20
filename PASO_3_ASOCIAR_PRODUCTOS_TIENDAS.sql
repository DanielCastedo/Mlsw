-- ============================================
-- PASO 3: ASOCIAR PRODUCTOS A TIENDAS CON PRECIOS
-- ============================================
-- 
-- QUE HACE ESTE SCRIPT?
-- Asocia cada producto a las tiendas con precios y stock variados
-- Esto es CRUCIAL para Machine Learning porque:
--   - Cada producto estara en VARIAS tiendas
--   - Cada tienda tendra precios DIFERENTES
--   - El modelo aprendera: "Las manzanas suelen costar entre X y Y"
--
-- COMO USARLO:
-- 1. Abre pgAdmin
-- 2. Conectate a "PrecioSw2"
-- 3. Abre Query Tool
-- 4. Copia y pega este script completo
-- 5. Ejecuta (F5)
--
-- IMPORTANTE:
-- Este script asocia productos a tiendas
-- Si una relacion ya existe, la actualizara con nuevos precios
-- ============================================

-- Primero, obtener los IDs de las tiendas
-- (Asumimos que tienes tienda1 con id=1 y tienda2 con id=2)
-- Si tus IDs son diferentes, ajustalos abajo

-- LIMPIAR relaciones existentes (opcional - solo si quieres empezar de cero)
-- DELETE FROM tienda_producto;  -- Descomenta esta linea si quieres borrar todo

-- ============================================
-- ASOCIAR PRODUCTOS A TIENDA1 Y TIENDA2
-- ============================================
-- Cada producto estara en AMBAS tiendas con precios diferentes
-- Esto le da al modelo ejemplos variados para aprender

-- FRUTAS en ambas tiendas con precios variados
INSERT INTO tienda_producto (tienda_id, producto_id, precio, stock, created_at, updated_at)
VALUES 
    -- Banana (producto_id = 2 o 5)
    (1, 2, 3.00, 30, NOW(), NOW()),
    (2, 2, 3.50, 25, NOW(), NOW()),
    
    -- Mandarina (producto_id = 4 o 6)
    (1, 4, 2.50, 40, NOW(), NOW()),
    (2, 4, 2.00, 89, NOW(), NOW()),
    
    -- Manzana (producto_id = 7)
    (1, 7, 4.50, 35, NOW(), NOW()),
    (2, 7, 5.00, 30, NOW(), NOW()),
    
    -- Naranja (producto_id = 8)
    (1, 8, 3.80, 40, NOW(), NOW()),
    (2, 8, 4.20, 35, NOW(), NOW()),
    
    -- Uva (producto_id = 9)
    (1, 9, 6.50, 20, NOW(), NOW()),
    (2, 9, 7.00, 18, NOW(), NOW()),
    
    -- Fresa (producto_id = 10)
    (1, 10, 5.50, 25, NOW(), NOW()),
    (2, 10, 6.00, 22, NOW(), NOW()),
    
    -- Mango (producto_id = 11)
    (1, 11, 4.80, 30, NOW(), NOW()),
    (2, 11, 5.20, 28, NOW(), NOW()),
    
    -- Piña (producto_id = 12)
    (1, 12, 3.50, 20, NOW(), NOW()),
    (2, 12, 4.00, 18, NOW(), NOW()),
    
    -- Papaya (producto_id = 13)
    (1, 13, 4.20, 25, NOW(), NOW()),
    (2, 13, 4.50, 23, NOW(), NOW()),
    
    -- Limon (producto_id = 14)
    (1, 14, 2.80, 50, NOW(), NOW()),
    (2, 14, 3.20, 45, NOW(), NOW()),
    
    -- Kiwi (producto_id = 15)
    (1, 15, 5.80, 20, NOW(), NOW()),
    (2, 15, 6.20, 18, NOW(), NOW()),
    
    -- Pera (producto_id = 16)
    (1, 16, 4.00, 30, NOW(), NOW()),
    (2, 16, 4.50, 28, NOW(), NOW()),
    
    -- Durazno (producto_id = 17)
    (1, 17, 5.00, 25, NOW(), NOW()),
    (2, 17, 5.50, 23, NOW(), NOW()),
    
    -- Sandia (producto_id = 18)
    (1, 18, 2.50, 15, NOW(), NOW()),
    (2, 18, 3.00, 12, NOW(), NOW()),
    
    -- Melon (producto_id = 19)
    (1, 19, 3.20, 18, NOW(), NOW()),
    (2, 19, 3.80, 15, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- VERDURAS en ambas tiendas con precios variados
INSERT INTO tienda_producto (tienda_id, producto_id, precio, stock, created_at, updated_at)
VALUES 
    -- Lechuga (producto_id = 1 o 20)
    (1, 1, 9.00, 5, NOW(), NOW()),
    (2, 1, 8.50, 8, NOW(), NOW()),
    
    -- Pimenton (producto_id = 3 o 21)
    (1, 3, 4.50, 25, NOW(), NOW()),
    (2, 3, 4.00, 70, NOW(), NOW()),
    
    -- Tomate (producto_id = 22)
    (1, 22, 3.50, 40, NOW(), NOW()),
    (2, 22, 4.00, 35, NOW(), NOW()),
    
    -- Cebolla (producto_id = 23)
    (1, 23, 2.80, 50, NOW(), NOW()),
    (2, 23, 3.20, 45, NOW(), NOW()),
    
    -- Zanahoria (producto_id = 24)
    (1, 24, 2.50, 45, NOW(), NOW()),
    (2, 24, 3.00, 40, NOW(), NOW()),
    
    -- Brocoli (producto_id = 25)
    (1, 25, 5.50, 20, NOW(), NOW()),
    (2, 25, 6.00, 18, NOW(), NOW()),
    
    -- Coliflor (producto_id = 26)
    (1, 26, 4.80, 22, NOW(), NOW()),
    (2, 26, 5.20, 20, NOW(), NOW()),
    
    -- Espinaca (producto_id = 27)
    (1, 27, 3.20, 30, NOW(), NOW()),
    (2, 27, 3.50, 28, NOW(), NOW()),
    
    -- Pepino (producto_id = 28)
    (1, 28, 2.80, 35, NOW(), NOW()),
    (2, 28, 3.20, 32, NOW(), NOW()),
    
    -- Ajo (producto_id = 29)
    (1, 29, 8.00, 20, NOW(), NOW()),
    (2, 29, 8.50, 18, NOW(), NOW()),
    
    -- Apio (producto_id = 30)
    (1, 30, 3.50, 25, NOW(), NOW()),
    (2, 30, 4.00, 23, NOW(), NOW()),
    
    -- Repollo (producto_id = 31)
    (1, 31, 2.50, 30, NOW(), NOW()),
    (2, 31, 3.00, 28, NOW(), NOW()),
    
    -- Rabano (producto_id = 32)
    (1, 32, 2.20, 35, NOW(), NOW()),
    (2, 32, 2.50, 32, NOW(), NOW()),
    
    -- Calabaza (producto_id = 33)
    (1, 33, 3.80, 20, NOW(), NOW()),
    (2, 33, 4.20, 18, NOW(), NOW()),
    
    -- Berenjena (producto_id = 34)
    (1, 34, 4.50, 22, NOW(), NOW()),
    (2, 34, 5.00, 20, NOW(), NOW()),
    
    -- Choclo (producto_id = 35)
    (1, 35, 2.80, 40, NOW(), NOW()),
    (2, 35, 3.20, 38, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- ============================================
-- VERIFICAR RESULTADOS
-- ============================================

-- Ver cuantos productos estan en cada tienda
SELECT 
    t.nombre as tienda,
    COUNT(tp.id) as total_productos,
    AVG(tp.precio) as precio_promedio,
    SUM(tp.stock) as stock_total
FROM tiendas t
LEFT JOIN tienda_producto tp ON t.id = tp.tienda_id
GROUP BY t.id, t.nombre;

-- Ver productos con sus precios en diferentes tiendas
SELECT 
    p.nombre as producto,
    c.nombre as categoria,
    COUNT(DISTINCT tp.tienda_id) as num_tiendas,
    MIN(tp.precio) as precio_minimo,
    MAX(tp.precio) as precio_maximo,
    AVG(tp.precio) as precio_promedio
FROM productos p
JOIN categorias c ON p.categoria_id = c.id
LEFT JOIN tienda_producto tp ON p.id = tp.producto_id
GROUP BY p.id, p.nombre, c.nombre
HAVING COUNT(tp.id) > 0
ORDER BY c.nombre, p.nombre;

-- Total de relaciones creadas
SELECT COUNT(*) as total_relaciones_producto_tienda FROM tienda_producto;

