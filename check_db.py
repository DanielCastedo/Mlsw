import os
from sqlalchemy import create_engine, text

# Leer variables de entorno o usar las proporcionadas directamente
DB_HOST = os.environ.get('DB_HOST', 'dpg-d4fd6n15pdvs73adlqdg-a.oregon-postgres.render.com')
DB_PORT = os.environ.get('DB_PORT', '5432')
DB_DATABASE = os.environ.get('DB_DATABASE', 'sw2precio')
DB_USERNAME = os.environ.get('DB_USERNAME', 'sw2precio')
DB_PASSWORD = os.environ.get('DB_PASSWORD', 'C6zWxNSFIgit2ZzR0SFy0nmU5tC4POUK')
DB_SSLMODE = os.environ.get('DB_SSLMODE', 'require')

conn_str = f"postgresql://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_DATABASE}?sslmode={DB_SSLMODE}"

print('Intentando conectar con:', conn_str)

try:
    engine = create_engine(conn_str)
    with engine.connect() as conn:
        print('\nConexión establecida. Ejecutando consultas de comprobación...')
        r = conn.execute(text('SELECT version()'))
        version = r.fetchone()[0]
        print('Postgres version:', version)

        r2 = conn.execute(text("SELECT table_schema, table_name FROM information_schema.tables WHERE table_schema='public' LIMIT 10"))
        tables = r2.fetchall()
        if tables:
            print('\nTablas públicas (hasta 10):')
            for schema, name in tables:
                print(f' - {schema}.{name}')
        else:
            print('\nNo se encontraron tablas públicas.')

    engine.dispose()
    print('\nComprobación finalizada correctamente.')
except Exception as e:
    print('\nERROR conectando a la base de datos:')
    print(e)
    raise
