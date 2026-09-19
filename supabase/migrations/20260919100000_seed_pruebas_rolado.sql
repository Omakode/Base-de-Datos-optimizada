-- Seed de pruebas para validación de roles, organización, chat y contador.
-- Este archivo crea registros de prueba sin depender de usuarios reales de auth.
-- Requiere que existan roles, organizaciones, estatus y catálogos base.

-- ------------------------------------------------------------
-- 1. Organizaciones
-- ------------------------------------------------------------
insert into public.organizaciones (id, nombre)
values
    ('11111111-1111-1111-1111-111111111111', 'Org A'),
    ('22222222-2222-2222-2222-222222222222', 'Org B')
on conflict (id) do nothing;

-- ------------------------------------------------------------
-- 2. Roles
-- ------------------------------------------------------------
-- Se asume que ya existen owner/admin/contador/cliente en la base.

-- ------------------------------------------------------------
-- 3. Usuarios de prueba
-- Se crean primero en auth.users para respetar la FK usuarios.id -> auth.users.id.
-- El trigger public.nuevo_usuario() llena public.usuarios desde raw_user_meta_data.
-- ------------------------------------------------------------
insert into auth.users (
    id,
    instance_id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    created_at,
    updated_at,
    raw_user_meta_data
)
values
    (
        'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'::uuid,
        '00000000-0000-0000-0000-000000000000'::uuid,
        'authenticated',
        'authenticated',
        'owner@orga.test',
        'placeholder_hash',
        now(),
        now(),
        now(),
        jsonb_build_object(
            'nombre', 'Owner',
            'apellido_paterno', 'Uno',
            'apellido_materno', 'Admin',
            'rol_id', (select id from public.roles where lower(nombre) = 'owner')::text,
            'organizacion_id', '11111111-1111-1111-1111-111111111111'::text,
            'contador_id', null,
            'regimen_fiscal_id', null
        )
    ),
    (
        'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'::uuid,
        '00000000-0000-0000-0000-000000000000'::uuid,
        'authenticated',
        'authenticated',
        'admin@orga.test',
        'placeholder_hash',
        now(),
        now(),
        now(),
        jsonb_build_object(
            'nombre', 'Admin',
            'apellido_paterno', 'Dos',
            'apellido_materno', 'OrgA',
            'rol_id', (select id from public.roles where lower(nombre) = 'admin')::text,
            'organizacion_id', '11111111-1111-1111-1111-111111111111'::text,
            'contador_id', null,
            'regimen_fiscal_id', null
        )
    ),
    (
        'cccccccc-cccc-4ccc-8ccc-cccccccccccc'::uuid,
        '00000000-0000-0000-0000-000000000000'::uuid,
        'authenticated',
        'authenticated',
        'contador1@orga.test',
        'placeholder_hash',
        now(),
        now(),
        now(),
        jsonb_build_object(
            'nombre', 'Contador',
            'apellido_paterno', 'Tres',
            'apellido_materno', 'OrgA',
            'rol_id', (select id from public.roles where lower(nombre) = 'contador')::text,
            'organizacion_id', '11111111-1111-1111-1111-111111111111'::text,
            'contador_id', null,
            'regimen_fiscal_id', null
        )
    ),
    (
        'dddddddd-dddd-4ddd-8ddd-dddddddddddd'::uuid,
        '00000000-0000-0000-0000-000000000000'::uuid,
        'authenticated',
        'authenticated',
        'cliente1@orga.test',
        'placeholder_hash',
        now(),
        now(),
        now(),
        jsonb_build_object(
            'nombre', 'Cliente',
            'apellido_paterno', 'Cuatro',
            'apellido_materno', 'OrgA',
            'rol_id', (select id from public.roles where lower(nombre) = 'cliente')::text,
            'organizacion_id', '11111111-1111-1111-1111-111111111111'::text,
            'contador_id', 'cccccccc-cccc-4ccc-8ccc-cccccccccccc'::text,
            'regimen_fiscal_id', null
        )
    ),
    (
        'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee'::uuid,
        '00000000-0000-0000-0000-000000000000'::uuid,
        'authenticated',
        'authenticated',
        'cliente2@orga.test',
        'placeholder_hash',
        now(),
        now(),
        now(),
        jsonb_build_object(
            'nombre', 'Cliente',
            'apellido_paterno', 'Cinco',
            'apellido_materno', 'OrgA',
            'rol_id', (select id from public.roles where lower(nombre) = 'cliente')::text,
            'organizacion_id', '11111111-1111-1111-1111-111111111111'::text,
            'contador_id', 'cccccccc-cccc-4ccc-8ccc-cccccccccccc'::text,
            'regimen_fiscal_id', null
        )
    ),
    (
        'ffffffff-ffff-4fff-8fff-ffffffffffff'::uuid,
        '00000000-0000-0000-0000-000000000000'::uuid,
        'authenticated',
        'authenticated',
        'admin@orgb.test',
        'placeholder_hash',
        now(),
        now(),
        now(),
        jsonb_build_object(
            'nombre', 'Admin',
            'apellido_paterno', 'Seis',
            'apellido_materno', 'OrgB',
            'rol_id', (select id from public.roles where lower(nombre) = 'admin')::text,
            'organizacion_id', '22222222-2222-2222-2222-222222222222'::text,
            'contador_id', null,
            'regimen_fiscal_id', null
        )
    ),
    (
        '12121212-1212-4121-8121-121212121212'::uuid,
        '00000000-0000-0000-0000-000000000000'::uuid,
        'authenticated',
        'authenticated',
        'contador2@orgb.test',
        'placeholder_hash',
        now(),
        now(),
        now(),
        jsonb_build_object(
            'nombre', 'Contador',
            'apellido_paterno', 'Siete',
            'apellido_materno', 'OrgB',
            'rol_id', (select id from public.roles where lower(nombre) = 'contador')::text,
            'organizacion_id', '22222222-2222-2222-2222-222222222222'::text,
            'contador_id', null,
            'regimen_fiscal_id', null
        )
    ),
    (
        '13131313-1313-4131-8131-131313131313'::uuid,
        '00000000-0000-0000-0000-000000000000'::uuid,
        'authenticated',
        'authenticated',
        'cliente3@orgb.test',
        'placeholder_hash',
        now(),
        now(),
        now(),
        jsonb_build_object(
            'nombre', 'Cliente',
            'apellido_paterno', 'Ocho',
            'apellido_materno', 'OrgB',
            'rol_id', (select id from public.roles where lower(nombre) = 'cliente')::text,
            'organizacion_id', '22222222-2222-2222-2222-222222222222'::text,
            'contador_id', '12121212-1212-4121-8121-121212121212'::text,
            'regimen_fiscal_id', null
        )
    )
on conflict (id) do nothing;

-- ------------------------------------------------------------
-- 4. Cotizaciones y actividades
-- ------------------------------------------------------------
insert into public.cotizaciones (
    id, organizacion_id, titulo, descripcion, precio, cliente_id, estatus_id, actividad_catalogo_id
)
select v.id,
       v.organizacion_id,
       v.titulo,
       v.descripcion,
       v.precio,
       v.cliente_id,
       (select id from public.estatus_cotizacion e where lower(e.nombre) = lower(v.estatus_name) limit 1),
       (select id from public.lista_actividades limit 1)
from (
    values
        (
            'a1111111-1111-4111-8111-111111111111'::uuid,
            '11111111-1111-1111-1111-111111111111'::uuid,
            'Cotización A', 'Cotización para cliente 1', 1500.00,
            'dddddddd-dddd-4ddd-8ddd-dddddddddddd'::uuid,
            'pendiente'
        ),
        (
            'a2222222-2222-4222-8222-222222222222'::uuid,
            '22222222-2222-2222-2222-222222222222'::uuid,
            'Cotización B', 'Cotización para cliente 3', 2200.00,
            '13131313-1313-4131-8131-131313131313'::uuid,
            'aceptada'
        )
    ) as v(id, organizacion_id, titulo, descripcion, precio, cliente_id, estatus_name)
on conflict (id) do nothing;

insert into public.actividades (
    id, organizacion_id, cotizacion_id, cliente_id, contador_id, titulo, descripcion, precio, estatus_id
)
select v.id, v.organizacion_id, v.cotizacion_id, v.cliente_id, v.contador_id, v.titulo, v.descripcion, v.precio, e.id
from (
    values
        (
            'b1111111-1111-4111-8111-111111111111'::uuid,
            '11111111-1111-1111-1111-111111111111'::uuid,
            'a1111111-1111-4111-8111-111111111111'::uuid,
            'dddddddd-dddd-4ddd-8ddd-dddddddddddd'::uuid,
            'cccccccc-cccc-4ccc-8ccc-cccccccccccc'::uuid,
            'Actividad A', 'Actividad de cliente 1', 1500.00,
            'pendiente'
        ),
        (
            'b2222222-2222-4222-8222-222222222222'::uuid,
            '22222222-2222-2222-2222-222222222222'::uuid,
            'a2222222-2222-4222-8222-222222222222'::uuid,
            '13131313-1313-4131-8131-131313131313'::uuid,
            '12121212-1212-4121-8121-121212121212'::uuid,
            'Actividad B', 'Actividad de cliente 3', 2200.00,
            'en_proceso'
        )
) as v(id, organizacion_id, cotizacion_id, cliente_id, contador_id, titulo, descripcion, precio, estatus_name)
join public.estatus_actividad e on lower(e.nombre) = lower(v.estatus_name)
where true
on conflict (id) do nothing;

-- ------------------------------------------------------------
-- 5. Carpetas y documentos
-- ------------------------------------------------------------
insert into public.carpetas (id, organizacion_id, cliente_id, nombre)
values
    ('c1111111-1111-4111-8111-111111111111'::uuid, '11111111-1111-1111-1111-111111111111'::uuid, 'dddddddd-dddd-4ddd-8ddd-dddddddddddd'::uuid, 'General'),
    ('c2222222-2222-4222-8222-222222222222'::uuid, '22222222-2222-2222-2222-222222222222'::uuid, '13131313-1313-4131-8131-131313131313'::uuid, 'General')
on conflict (id) do nothing;

insert into public.documentos (
    id, organizacion_id, actividad_id, carpeta_id, cliente_id, subido_por_id,
    nombre_archivo, ruta_archivo, categoria_documento_id
)
select v.id, v.organizacion_id, v.actividad_id, v.carpeta_id, v.cliente_id, v.subido_por_id,
       v.nombre_archivo, v.ruta_archivo, cd.id
from (
    values
        (
            'd1111111-1111-4111-8111-111111111111'::uuid,
            '11111111-1111-1111-1111-111111111111'::uuid,
            'b1111111-1111-4111-8111-111111111111'::uuid,
            null,
            'dddddddd-dddd-4ddd-8ddd-dddddddddddd'::uuid,
            'dddddddd-dddd-4ddd-8ddd-dddddddddddd'::uuid,
            'factura_cliente_1.pdf',
            'documentos/factura_cliente_1.pdf',
            'Identificación oficial (INE / Pasaporte)'
        ),
        (
            'd2222222-2222-4222-8222-222222222222'::uuid,
            '22222222-2222-2222-2222-222222222222'::uuid,
            null,
            'c2222222-2222-4222-8222-222222222222'::uuid,
            '13131313-1313-4131-8131-131313131313'::uuid,
            '13131313-1313-4131-8131-131313131313'::uuid,
            'comprobante_orgb.pdf',
            'documentos/comprobante_orgb.pdf',
            'Comprobante de domicilio'
        )
) as v(id, organizacion_id, actividad_id, carpeta_id, cliente_id, subido_por_id, nombre_archivo, ruta_archivo, categoria_nombre)
join public.categoria_documentos cd on lower(cd.nombre) = lower(v.categoria_nombre)
where true
on conflict (id) do nothing;

-- ------------------------------------------------------------
-- 6. Conversaciones y mensajes
-- ------------------------------------------------------------
insert into public.conversaciones (
    id, organizacion_id, tipo, cliente_id, contador_id, admin_id, actividad_id
)
values
    (
        'e1111111-1111-4111-8111-111111111111'::uuid,
        '11111111-1111-1111-1111-111111111111'::uuid,
        'contador_cliente',
        'dddddddd-dddd-4ddd-8ddd-dddddddddddd'::uuid,
        'cccccccc-cccc-4ccc-8ccc-cccccccccccc'::uuid,
        null,
        'b1111111-1111-4111-8111-111111111111'::uuid
    ),
    (
        'e2222222-2222-4222-8222-222222222222'::uuid,
        '11111111-1111-1111-1111-111111111111'::uuid,
        'cliente_admin',
        'dddddddd-dddd-4ddd-8ddd-dddddddddddd'::uuid,
        null,
        'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'::uuid,
        null
    ),
    (
        'e3333333-3333-4333-8333-333333333333'::uuid,
        '22222222-2222-2222-2222-222222222222'::uuid,
        'contador_cliente',
        '13131313-1313-4131-8131-131313131313'::uuid,
        '12121212-1212-4121-8121-121212121212'::uuid,
        null,
        'b2222222-2222-4222-8222-222222222222'::uuid
    )
on conflict (id) do nothing;

insert into public.mensajes (id, conversacion_id, remitente_id, contenido)
values
    ('91111111-1111-4111-8111-111111111111'::uuid, 'e1111111-1111-4111-8111-111111111111'::uuid, 'dddddddd-dddd-4ddd-8ddd-dddddddddddd'::uuid, 'Hola, te comparto la documentación.'),
    ('92222222-2222-4222-8222-222222222222'::uuid, 'e1111111-1111-4111-8111-111111111111'::uuid, 'cccccccc-cccc-4ccc-8ccc-cccccccccccc'::uuid, 'Gracias, reviso los documentos.'),
    ('93333333-3333-4333-8333-333333333333'::uuid, 'e2222222-2222-4222-8222-222222222222'::uuid, 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'::uuid, 'Necesito más información del cliente.'),
    ('94444444-4444-4444-8444-444444444444'::uuid, 'e3333333-3333-4333-8333-333333333333'::uuid, '12121212-1212-4121-8121-121212121212'::uuid, 'Revisé la actividad y te respondo enseguida.')
on conflict (id) do nothing;
