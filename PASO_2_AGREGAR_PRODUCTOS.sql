-- ============================================
-- PASO 2: AGREGAR PRODUCTOS
-- ============================================
-- 
-- QUE HACE ESTE SCRIPT?
-- Agrega 25 productos nuevos a tu base de datos
-- Usa las categorias que ya tienes:
--   - categoria_id = 1 (verduras)
--   - categoria_id = 2 (frutas)
--
-- COMO USARLO:
-- 1. Abre pgAdmin
-- 2. Conectate a tu base de datos "PrecioSw2"
-- 3. Abre Query Tool
-- 4. Copia y pega este script completo
-- 5. Ejecuta (F5)
--
-- IMPORTANTE:
-- Este script agrega productos nuevos
-- Si un producto ya existe, lo saltara (no dara error)
-- ============================================

-- PRODUCTOS DE FRUTAS (categoria_id = 2)
INSERT INTO productos (categoria_id, nombre, descripcion, created_at, updated_at)
VALUES 
    -- Frutas que ya tienes (se saltaran si existen)
    (2, 'banana', 'Platano amarillo', NOW(), NOW()),
    (2, 'mandarina', 'Mandarina dulce', NOW(), NOW()),
    
    -- Nuevas frutas
    (2, 'manzana', 'Manzana roja fresca', NOW(), NOW()),
    (2, 'naranja', 'Naranja jugosa', NOW(), NOW()),
    (2, 'uva', 'Uvas verdes', NOW(), NOW()),
    (2, 'fresa', 'Fresas rojas', NOW(), NOW()),
    (2, 'mango', 'Mango maduro', NOW(), NOW()),
    (2, 'piña', 'Piña dulce', NOW(), NOW()),
    (2, 'papaya', 'Papaya fresca', NOW(), NOW()),
    (2, 'limon', 'Limon amarillo', NOW(), NOW()),
    (2, 'kiwi', 'Kiwi verde', NOW(), NOW()),
    (2, 'pera', 'Pera jugosa', NOW(), NOW()),
    (2, 'durazno', 'Durazno dulce', NOW(), NOW()),
    (2, 'sandia', 'Sandia fresca', NOW(), NOW()),
    (2, 'melon', 'Melon dulce', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- PRODUCTOS DE VERDURAS (categoria_id = 1)
INSERT INTO productos (categoria_id, nombre, descripcion, created_at, updated_at)
VALUES 
    -- Verduras que ya tienes (se saltaran si existen)
    (1, 'lechuga', 'Lechuga fresca', NOW(), NOW()),
    (1, 'pimenton', 'Pimenton rojo', NOW(), NOW()),
    
    -- Nuevas verduras
    (1, 'tomate', 'Tomate rojo', NOW(), NOW()),
    (1, 'cebolla', 'Cebolla blanca', NOW(), NOW()),
    (1, 'zanahoria', 'Zanahoria naranja', NOW(), NOW()),
    (1, 'brocoli', 'Brocoli fresco', NOW(), NOW()),
    (1, 'coliflor', 'Coliflor blanca', NOW(), NOW()),
    (1, 'espinaca', 'Espinaca fresca', NOW(), NOW()),
    (1, 'pepino', 'Pepino verde', NOW(), NOW()),
    (1, 'ajo', 'Ajo fresco', NOW(), NOW()),
    (1, 'apio', 'Apio verde', NOW(), NOW()),
    (1, 'repollo', 'Repollo verde', NOW(), NOW()),
    (1, 'rabano', 'Rabano rojo', NOW(), NOW()),
    (1, 'calabaza', 'Calabaza naranja', NOW(), NOW()),
    (1, 'berenjena', 'Berenjena morada', NOW(), NOW()),
    (1, 'choclo', 'Choclo amarillo', NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Verificar productos agregados
SELECT 'Productos agregados:' as mensaje;
SELECT 
    p.id,
    p.nombre,
    c.nombre as categoria,
    COUNT(tp.id) as en_tiendas
FROM productos p
JOIN categorias c ON p.categoria_id = c.id
LEFT JOIN tienda_producto tp ON p.id = tp.producto_id
GROUP BY p.id, p.nombre, c.nombre
ORDER BY c.nombre, p.nombre;

-- Mostrar total
SELECT COUNT(*) as total_productos FROM productos;

