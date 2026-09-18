-- ============================================================
-- 01 — SCHEMA (consolidado)
-- Reemplaza: 20260809054140_catalagos.sql
--            20260809054453_tablas_importantes.sql
--            20260830225105_correciones_usuario.sql
--            20260902032734_correccion_new_user_trigger.sql (el ALTER de apellido_materno)
--            20260908203446_activos.sql
-- ============================================================

-- ------------------------------------------------------------
-- catálogos
-- ------------------------------------------------------------
create table roles (
    id     uuid primary key default gen_random_uuid(),
    nombre varchar(255) not null
);

create table estatus_usuarios (
    id     uuid primary key default gen_random_uuid(),
    nombre varchar(255)
);

create table estatus_cotizacion (
    id     uuid primary key default gen_random_uuid(),
    nombre varchar(255)
);

create table estatus_actividad (
    id     uuid primary key default gen_random_uuid(),
    nombre varchar(255)
);

create table regimenes_fiscales (
    id     uuid    primary key default gen_random_uuid(),
    nombre varchar(255),
    activo boolean default true
);

create table especialidad_contador (
    id     uuid    primary key default gen_random_uuid(),
    nombre varchar(255) not null,
    activo boolean default true
);

create table categorias (
    id     uuid primary key default gen_random_uuid(),
    nombre varchar(255) not null
);

create table catalogo_actividades (
    id     uuid    primary key default gen_random_uuid(),
    nombre varchar(255) not null,
    activo boolean
);

create table lista_actividades (
    id                    uuid primary key default gen_random_uuid(),
    categoria_id          uuid references categorias(id),
    catalogo_actividad_id uuid references catalogo_actividades(id)
);

create table categoria_documentos (
    id     uuid    primary key default gen_random_uuid(),
    nombre varchar(255) not null,
    activo boolean default true
);


-- ------------------------------------------------------------
-- tablas principales
-- ------------------------------------------------------------
create table organizaciones (
    id     uuid primary key default gen_random_uuid(),
    nombre varchar(255) not null
);

create table usuarios (
    id                uuid primary key references auth.users(id),
    nombre            varchar(255) not null,
    apellido_paterno  varchar(255) not null,
    apellido_materno  varchar(255),
    email             varchar(255) unique not null,
    rfc               varchar(25),
    estatus_id        uuid references estatus_usuarios(id),
    regimen_fiscal_id uuid references regimenes_fiscales(id),
    rol_id            uuid references roles(id) not null,
    contador_id       uuid references usuarios(id),
    organizacion_id   uuid references organizaciones(id),
    fecha_creacion    timestamp not null default now()
);

create table cotizaciones (
    id                    uuid primary key default gen_random_uuid(),
    organizacion_id       uuid references organizaciones(id) not null,
    titulo                varchar(255) not null,
    descripcion           text,
    precio                numeric(10,2),
    cliente_id            uuid references usuarios(id) not null,
    estatus_id            uuid references estatus_cotizacion(id),
    actividad_catalogo_id uuid references lista_actividades(id),
    fecha_creacion        timestamp not null default now()
);

create table actividades (
    id              uuid primary key default gen_random_uuid(),
    organizacion_id uuid references organizaciones(id) not null,
    cotizacion_id   uuid references cotizaciones(id) not null,
    cliente_id      uuid references usuarios(id) not null,
    contador_id     uuid references usuarios(id) not null,
    titulo          varchar(255) not null,
    descripcion     text,
    precio          numeric(10,2),
    estatus_id      uuid references estatus_actividad(id),
    fecha_creacion  timestamp not null default now()
);

create table carpetas (
    id              uuid primary key default gen_random_uuid(),
    organizacion_id uuid references organizaciones(id) not null,
    cliente_id      uuid references usuarios(id) not null,
    nombre          varchar(255) not null default 'General',
    fecha_creacion  timestamp not null default now()
);

create table documentos (
    id                     uuid primary key default gen_random_uuid(),
    organizacion_id        uuid references organizaciones(id) not null,
    actividad_id           uuid references actividades(id),
    carpeta_id             uuid references carpetas(id),
    cliente_id             uuid references usuarios(id) not null,
    subido_por_id          uuid references usuarios(id) not null,
    nombre_archivo         varchar(255) not null,
    ruta_archivo           varchar(255) not null,
    categoria_documento_id uuid references categoria_documentos(id),
    fecha_subida           timestamp not null default now(),

    constraint chk_documento_destino check (
        (actividad_id is not null and carpeta_id is null) or
        (actividad_id is null and carpeta_id is not null)
    )
);

create table conversaciones (
    id              uuid primary key default gen_random_uuid(),
    organizacion_id uuid references organizaciones(id) not null,
    tipo            varchar(20) not null check (tipo in ('contador_cliente', 'cliente_admin')),
    cliente_id      uuid references usuarios(id) not null,
    contador_id     uuid references usuarios(id),
    admin_id        uuid references usuarios(id),
    cotizacion_id   uuid references cotizaciones(id),
    actividad_id    uuid references actividades(id),
    fecha_creacion  timestamp not null default now(),
    constraint chk_conversacion_participantes check (
        (tipo = 'contador_cliente' and contador_id is not null and admin_id is null) or
        (tipo = 'cliente_admin'    and admin_id    is not null and contador_id is null)
    )
);

create table mensajes (
    id              uuid primary key default gen_random_uuid(),
    conversacion_id uuid references conversaciones(id) not null,
    remitente_id    uuid references usuarios(id) not null,
    contenido       text not null,
    fecha_envio     timestamp not null default now()
);