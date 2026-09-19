-- Seed de pruebas compatible con la FK usuarios.id -> auth.users.id.
-- Se crean primero los usuarios de auth.users y el trigger public.nuevo_usuario()
-- completa la fila en public.usuarios desde raw_user_meta_data.

insert into public.organizaciones (id, nombre)
values
    ('11111111-1111-1111-1111-111111111111'::uuid, 'Org A'),
    ('22222222-2222-2222-2222-222222222222'::uuid, 'Org B')
on conflict (id) do nothing;

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

-- El trigger public.nuevo_usuario() crea automáticamente public.usuarios.
-- Si se desea crear clientes con contador y org ya asignados, basta con insertar en auth.users
-- y dejar que el trigger llene public.usuarios desde raw_user_meta_data.
