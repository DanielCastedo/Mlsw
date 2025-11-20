-- ============================================
-- PASO 1: AGREGAR CATEGORIAS
-- ============================================
-- 
-- QUE HACE ESTE SCRIPT?
-- Agrega categorias de productos si no las tienes
-- Las categorias son necesarias porque cada producto debe pertenecer a una
--
-- COMO USARLO:
-- 1. Abre pgAdmin
-- 2. Conectate a tu base de datos "PrecioSw2"
-- 3. Abre la herramienta "Query Tool" (herramienta de consultas)
-- 4. Copia y pega este script
-- 5. Ejecuta (F5 o boton "Execute")
--
-- IMPORTANTE: 
-- Si ya tienes estas categorias, el script dara error pero no pasa nada
-- Solo significa que ya existen
-- ============================================

-- Insertar categorias comunes de supermercado
-- El "ON CONFLICT DO NOTHING" evita errores si ya existen

INSERT INTO categorias (nombre, descripcion, created_at, updated_at)
VALUES 
    ('Frutas', 'Frutas frescas', NOW(), NOW()),
    ('Verduras', 'Verduras y hortalizas', NOW(), NOW()),
    ('Lacteos', 'Leche, queso, yogurt', NOW(), NOW()),
    ('Carnes', 'Carnes y embutidos', NOW(), NOW()),
    ('Bebidas', 'Bebidas alcoholicas y no alcoholicas', NOW(), NOW()),
    ('Limpieza', 'Productos de limpieza del hogar', NOW(), NOW()),
    ('Panaderia', 'Pan, pasteles, galletas', NOW(), NOW()),
    ('Snacks', 'Papas fritas, dulces, golosinas', NOW(), NOW())
ON CONFLICT (nombre) DO NOTHING;

-- Verificar que se insertaron
SELECT 'Categorias agregadas:' as mensaje;
SELECT id, nombre FROM categorias ORDER BY id;

