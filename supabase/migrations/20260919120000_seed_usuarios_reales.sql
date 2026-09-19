insert into public.organizaciones (id, nombre)
values
    ('1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid, 'Despacho de Ali'),
    ('c2a2ba78-f1e0-460a-9876-dc33b8332e95'::uuid, 'Despacho de Wicho'),
    ('c44ef310-cba1-4278-8052-7e4521b52b43'::uuid, 'Despacho de Gilberto')
on conflict (id) do update
set nombre = excluded.nombre;

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
        '401838ec-6617-471e-a552-bed05104f12e'::uuid,
        '00000000-0000-0000-0000-000000000000'::uuid,
        'authenticated',
        'authenticated',
        'lriozcristobal@gmail.com',
        'placeholder_hash',
        now(),
        now(),
        now(),
        jsonb_build_object(
            'nombre', 'Luis Ali',
            'apellido_paterno', 'rios',
            'apellido_materno', null,
            'rfc', null,
            'rol_id', '67043be5-d1b4-48e1-9dca-00f710ab53f7',
            'organizacion_id', '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa',
            'contador_id', null,
            'regimen_fiscal_id', null
        )
    ),
    (
        '5e0642e0-c162-4e3b-a268-ea4a9dfcd9f7'::uuid,
        '00000000-0000-0000-0000-000000000000'::uuid,
        'authenticated',
        'authenticated',
        'omakod3@gmail.com',
        'placeholder_hash',
        now(),
        now(),
        now(),
        jsonb_build_object(
            'nombre', 'omakod3',
            'apellido_paterno', 'sisi',
            'apellido_materno', null,
            'rfc', null,
            'rol_id', 'b75a05eb-f139-4e21-8098-c63c99f8d248',
            'organizacion_id', '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa',
            'contador_id', null,
            'regimen_fiscal_id', null
        )
    ),
    (
        '78f4f1e1-ef59-4bc2-8f4a-4824b2afed07'::uuid,
        '00000000-0000-0000-0000-000000000000'::uuid,
        'authenticated',
        'authenticated',
        'luispm2424@gmail.com',
        'placeholder_hash',
        now(),
        now(),
        now(),
        jsonb_build_object(
            'nombre', 'Luis Alberto',
            'apellido_paterno', 'Wichincito',
            'apellido_materno', null,
            'rfc', null,
            'rol_id', '3e609a18-6276-416d-aff6-6b5a9bcf6688',
            'organizacion_id', '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa',
            'contador_id', null,
            'regimen_fiscal_id', null
        )
    ),
    (
        'b9cd15a4-49ee-44df-abdf-e6c587037c39'::uuid,
        '00000000-0000-0000-0000-000000000000'::uuid,
        'authenticated',
        'authenticated',
        'pablocesaraltuzar04@gmail.com',
        'placeholder_hash',
        now(),
        now(),
        now(),
        jsonb_build_object(
            'nombre', 'Pablo',
            'apellido_paterno', 'Altuzar',
            'apellido_materno', null,
            'rfc', 'GALJ900101ABC',
            'rol_id', '3e609a18-6276-416d-aff6-6b5a9bcf6688',
            'organizacion_id', '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa',
            'contador_id', null,
            'regimen_fiscal_id', null
        )
    )
on conflict (id) do nothing;

insert into public.usuarios (
    id,
    nombre,
    apellido_paterno,
    apellido_materno,
    email,
    rfc,
    estatus_id,
    regimen_fiscal_id,
    rol_id,
    contador_id,
    organizacion_id,
    especialidad_contador,
    fecha_creacion
)
values
    (
        '401838ec-6617-471e-a552-bed05104f12e'::uuid,
        'Luis Ali',
        'rios',
        null,
        'lriozcristobal@gmail.com',
        null,
        'cb4cb48a-7247-421e-a530-2771b1935092'::uuid,
        null,
        '67043be5-d1b4-48e1-9dca-00f710ab53f7'::uuid,
        null,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        null,
        '2026-09-14 02:35:35.909729'::timestamp
    ),
    (
        '5e0642e0-c162-4e3b-a268-ea4a9dfcd9f7'::uuid,
        'omakod3',
        'sisi',
        null,
        'omakod3@gmail.com',
        null,
        'cb4cb48a-7247-421e-a530-2771b1935092'::uuid,
        null,
        'b75a05eb-f139-4e21-8098-c63c99f8d248'::uuid,
        null,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        null,
        '2026-09-14 03:40:17.470983'::timestamp
    ),
    (
        '78f4f1e1-ef59-4bc2-8f4a-4824b2afed07'::uuid,
        'Luis Alberto',
        'Wichincito',
        null,
        'luispm2424@gmail.com',
        null,
        'cb4cb48a-7247-421e-a530-2771b1935092'::uuid,
        null,
        '3e609a18-6276-416d-aff6-6b5a9bcf6688'::uuid,
        null,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        null,
        '2026-09-14 02:34:54.166673'::timestamp
    ),
    (
        'b9cd15a4-49ee-44df-abdf-e6c587037c39'::uuid,
        'Pablo',
        'Altuzar',
        null,
        'pablocesaraltuzar04@gmail.com',
        'GALJ900101ABC',
        'cb4cb48a-7247-421e-a530-2771b1935092'::uuid,
        null,
        '3e609a18-6276-416d-aff6-6b5a9bcf6688'::uuid,
        null,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        null,
        '2026-09-19 07:33:40.02496'::timestamp
    )
on conflict (id) do update
set
    nombre = excluded.nombre,
    apellido_paterno = excluded.apellido_paterno,
    apellido_materno = excluded.apellido_materno,
    email = excluded.email,
    rfc = excluded.rfc,
    estatus_id = excluded.estatus_id,
    regimen_fiscal_id = excluded.regimen_fiscal_id,
    rol_id = excluded.rol_id,
    organizacion_id = excluded.organizacion_id,
    especialidad_contador = excluded.especialidad_contador,
    fecha_creacion = excluded.fecha_creacion;

update public.usuarios
set contador_id = '401838ec-6617-471e-a552-bed05104f12e'::uuid
where id = '401838ec-6617-471e-a552-bed05104f12e'::uuid;
