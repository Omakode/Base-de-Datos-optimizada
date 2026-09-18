-- ============================================================
-- 02 — RLS (consolidado)
-- Reemplaza: 20260813040234_rls_politicas.sql
--            20260906043945_policy_cliente.sql
--            20260906045706_policy_cliente2.sql (duplicado del anterior)
--            20260908205434_rls.sql
--
-- Cambio respecto al original: los 10 catálogos comunes quedan con
-- RLS HABILITADO (antes: disable + grant select) y una política de
-- lectura abierta a authenticated, en vez de desactivar RLS por
-- completo. Resultado funcional idéntico, pero pasa el Security
-- Advisor de Supabase y no depende únicamente de los GRANTs.
-- ============================================================

alter table roles                 enable row level security;
alter table estatus_usuarios      enable row level security;
alter table estatus_cotizacion    enable row level security;
alter table estatus_actividad     enable row level security;
alter table regimenes_fiscales    enable row level security;
alter table especialidad_contador enable row level security;
alter table categorias            enable row level security;
alter table catalogo_actividades  enable row level security;
alter table lista_actividades     enable row level security;
alter table categoria_documentos  enable row level security;

alter table organizaciones enable row level security;
alter table usuarios       enable row level security;
alter table actividades    enable row level security;
alter table cotizaciones   enable row level security;
alter table documentos     enable row level security;
alter table carpetas       enable row level security;
alter table conversaciones enable row level security;
alter table mensajes       enable row level security;

grant select, insert, update, delete on organizaciones to authenticated;
grant select, insert, update, delete on usuarios to authenticated;
grant select, insert, update, delete on actividades to authenticated;
grant select, insert, update, delete on cotizaciones to authenticated;
grant select, insert, update, delete on documentos to authenticated;
grant select, insert, update, delete on carpetas to authenticated;
grant select, insert, update, delete on conversaciones to authenticated;
grant select, insert, update, delete on mensajes to authenticated;
grant select on especialidad_contador, roles, catalogo_actividades, categorias,
    lista_actividades, regimenes_fiscales, estatus_usuarios, estatus_actividad,
    estatus_cotizacion, categoria_documentos to authenticated;


-- ------------------------------------------------------------
-- funciones auxiliares
-- ------------------------------------------------------------
create or replace function get_my_org_id()
returns uuid as $$
    select organizacion_id
    from public.usuarios
    where id = auth.uid();
$$ language sql stable security definer set search_path = public;

create or replace function get_my_role()
returns text as $$
    select lower(r.nombre)
    from public.roles r
    where r.id = (select rol_id from public.usuarios where id = auth.uid());
$$ language sql stable security definer set search_path = public;

create or replace function is_contador_de(p_cliente_id uuid)
returns boolean as $$
    select exists (
        select 1 from public.usuarios
        where id = p_cliente_id and contador_id = auth.uid()
    );
$$ language sql stable security definer set search_path = public;

create or replace function is_participante_conversacion(p_conversacion_id uuid)
returns boolean as $$
    select exists (
        select 1 from public.conversaciones
        where id = p_conversacion_id
        and (cliente_id = auth.uid() or contador_id = auth.uid() or admin_id = auth.uid())
    );
$$ language sql stable security definer set search_path = public;


-- ------------------------------------------------------------
-- catálogos comunes: lectura para cualquier autenticado
-- ------------------------------------------------------------
create policy "authenticated: leer catalogo" on roles                 for select to authenticated using (true);
create policy "authenticated: leer catalogo" on estatus_usuarios      for select to authenticated using (true);
create policy "authenticated: leer catalogo" on estatus_cotizacion    for select to authenticated using (true);
create policy "authenticated: leer catalogo" on estatus_actividad     for select to authenticated using (true);
create policy "authenticated: leer catalogo" on regimenes_fiscales    for select to authenticated using (true);
create policy "authenticated: leer catalogo" on especialidad_contador for select to authenticated using (true);
create policy "authenticated: leer catalogo" on categorias            for select to authenticated using (true);
create policy "authenticated: leer catalogo" on catalogo_actividades  for select to authenticated using (true);
create policy "authenticated: leer catalogo" on lista_actividades     for select to authenticated using (true);
create policy "authenticated: leer catalogo" on categoria_documentos  for select to authenticated using (true);

-- ------------------------------------------------------------
-- catálogos comunes: gestión (insert/update/delete) para owner y admin
-- ------------------------------------------------------------
create policy "owner_admin: gestionar catalogo" on roles for all to authenticated
    using (get_my_role() in ('owner', 'admin')) with check (get_my_role() in ('owner', 'admin'));
create policy "owner_admin: gestionar catalogo" on estatus_usuarios for all to authenticated
    using (get_my_role() in ('owner', 'admin')) with check (get_my_role() in ('owner', 'admin'));
create policy "owner_admin: gestionar catalogo" on estatus_cotizacion for all to authenticated
    using (get_my_role() in ('owner', 'admin')) with check (get_my_role() in ('owner', 'admin'));
create policy "owner_admin: gestionar catalogo" on estatus_actividad for all to authenticated
    using (get_my_role() in ('owner', 'admin')) with check (get_my_role() in ('owner', 'admin'));
create policy "owner_admin: gestionar catalogo" on regimenes_fiscales for all to authenticated
    using (get_my_role() in ('owner', 'admin')) with check (get_my_role() in ('owner', 'admin'));
create policy "owner_admin: gestionar catalogo" on especialidad_contador for all to authenticated
    using (get_my_role() in ('owner', 'admin')) with check (get_my_role() in ('owner', 'admin'));
create policy "owner_admin: gestionar catalogo" on categorias for all to authenticated
    using (get_my_role() in ('owner', 'admin')) with check (get_my_role() in ('owner', 'admin'));
create policy "owner_admin: gestionar catalogo" on catalogo_actividades for all to authenticated
    using (get_my_role() in ('owner', 'admin')) with check (get_my_role() in ('owner', 'admin'));
create policy "owner_admin: gestionar catalogo" on lista_actividades for all to authenticated
    using (get_my_role() in ('owner', 'admin')) with check (get_my_role() in ('owner', 'admin'));
create policy "owner_admin: gestionar catalogo" on categoria_documentos for all to authenticated
    using (get_my_role() in ('owner', 'admin')) with check (get_my_role() in ('owner', 'admin'));


-- ------------------------------------------------------------
-- organizaciones
-- ------------------------------------------------------------
create policy "owner: todas las organizaciones"
on organizaciones for all
using (get_my_role() = 'owner') with check (get_my_role() = 'owner');

create policy "admin: su organizacion"
on organizaciones for select
using (get_my_role() = 'admin' and id = get_my_org_id());

create policy "admin: actualizar su organizacion"
on organizaciones for update
using (get_my_role() = 'admin' and id = get_my_org_id())
with check (id = get_my_org_id());

create policy "contador: ver su organizacion"
on organizaciones for select
using (get_my_role() = 'contador' and id = get_my_org_id());

create policy "cliente: ver su organizacion"
on organizaciones for select
using (get_my_role() = 'cliente' and id = get_my_org_id());


-- ------------------------------------------------------------
-- usuarios
-- ------------------------------------------------------------
create policy "owner: control total usuarios"
on usuarios for all
using (get_my_role() = 'owner')
with check (get_my_role() = 'owner');

create policy "admin: gestionar usuarios de su organizacion"
on usuarios for all
using (
    get_my_role() = 'admin'
    and organizacion_id = get_my_org_id()
    and rol_id in (select id from roles where nombre in ('contador', 'cliente'))
)
with check (
    organizacion_id = get_my_org_id()
    and rol_id in (select id from roles where nombre in ('contador', 'cliente'))
);

create policy "todos: ver mi propio perfil"
on usuarios for select
using (id = auth.uid());

create policy "usuario: actualizar mi propio perfil"
on usuarios for update
using (id = auth.uid())
with check (id = auth.uid());

create policy "contador: ver a sus clientes asignados"
on usuarios for select
using (get_my_role() = 'contador' and contador_id = auth.uid());

-- versión final (post 20260906045706): lee el contador_id desde el
-- JWT en vez de una subconsulta a usuarios. Ojo: si reasignas el
-- contador de un cliente después del registro, esta policy sigue
-- viendo el valor viejo hasta refrescar el JWT / actualizar el
-- user_metadata.
create policy "cliente: ver a su contador asignado"
on usuarios for select
using (
    get_my_role() = 'cliente'
    and id = (auth.jwt() -> 'user_metadata' ->> 'contador_id')::uuid
);


-- ------------------------------------------------------------
-- actividades
-- ------------------------------------------------------------
create policy "owner: control total actividades"
on actividades for all
using (get_my_role() = 'owner')
with check (get_my_role() = 'owner');

create policy "admin: gestionar actividades de su organizacion"
on actividades for all
using (get_my_role() = 'admin' and organizacion_id = get_my_org_id())
with check (get_my_role() = 'admin' and organizacion_id = get_my_org_id());

create policy "contador: ver sus actividades asignadas"
on actividades for select
using (get_my_role() = 'contador' and contador_id = auth.uid());

create policy "contador: actualizar sus actividades asignadas"
on actividades for update
using (get_my_role() = 'contador' and contador_id = auth.uid())
with check (contador_id = auth.uid());

create policy "cliente: ver sus actividades"
on actividades for select
using (get_my_role() = 'cliente' and cliente_id = auth.uid());


-- ------------------------------------------------------------
-- cotizaciones
-- ------------------------------------------------------------
create policy "owner: control total cotizaciones"
on cotizaciones for all
using (get_my_role() = 'owner')
with check (get_my_role() = 'owner');

create policy "admin: gestionar cotizaciones de su organizacion"
on cotizaciones for all
using (get_my_role() = 'admin' and organizacion_id = get_my_org_id())
with check (organizacion_id = get_my_org_id());

create policy "contador: ver cotizaciones de sus clientes"
on cotizaciones for select
using (get_my_role() = 'contador' and is_contador_de(cliente_id));

create policy "cliente: ver mis cotizaciones"
on cotizaciones for select
using (get_my_role() = 'cliente' and cliente_id = auth.uid());

create policy "cliente: crear cotizaciones"
on cotizaciones for insert
with check (get_my_role() = 'cliente' and cliente_id = auth.uid() and organizacion_id = get_my_org_id());

create policy "cliente: editar mis cotizaciones"
on cotizaciones for update
using (get_my_role() = 'cliente' and cliente_id = auth.uid())
with check (cliente_id = auth.uid());


-- ------------------------------------------------------------
-- documentos
-- ------------------------------------------------------------
create policy "owner: control total documentos"
on documentos for all
using (get_my_role() = 'owner')
with check (get_my_role() = 'owner');

create policy "admin: gestionar documentos de su organizacion"
on documentos for all
using (get_my_role() = 'admin' and organizacion_id = get_my_org_id())
with check (organizacion_id = get_my_org_id());

create policy "contador: ver documentos de sus actividades"
on documentos for select
using (
    get_my_role() = 'contador'
    and actividad_id in (select id from actividades where contador_id = auth.uid())
);

create policy "contador: subir documentos a sus actividades"
on documentos for insert
with check (
    get_my_role() = 'contador'
    and subido_por_id = auth.uid()
    and organizacion_id = get_my_org_id()
    and carpeta_id is null
    and actividad_id in (select id from actividades where contador_id = auth.uid())
    and cliente_id = (select cliente_id from actividades where id = actividad_id)
);

create policy "cliente: ver mis documentos"
on documentos for select
using (get_my_role() = 'cliente' and cliente_id = auth.uid());

create policy "cliente: subir mis documentos"
on documentos for insert
with check (
    get_my_role() = 'cliente'
    and cliente_id = auth.uid()
    and subido_por_id = auth.uid()
    and organizacion_id = get_my_org_id()
);


-- ------------------------------------------------------------
-- carpetas
-- ------------------------------------------------------------
create policy "owner: control total carpetas"
on carpetas for all
using (get_my_role() = 'owner')
with check (get_my_role() = 'owner');

create policy "admin: gestionar carpetas de su organizacion"
on carpetas for all
using (get_my_role() = 'admin' and organizacion_id = get_my_org_id())
with check (organizacion_id = get_my_org_id());

create policy "contador: ver carpetas de sus clientes"
on carpetas for select
using (get_my_role() = 'contador' and is_contador_de(cliente_id));

create policy "cliente: ver mis carpetas"
on carpetas for select
using (get_my_role() = 'cliente' and cliente_id = auth.uid());

create policy "cliente: crear mis carpetas"
on carpetas for insert
with check (get_my_role() = 'cliente' and cliente_id = auth.uid() and organizacion_id = get_my_org_id());


-- ------------------------------------------------------------
-- conversaciones
-- ------------------------------------------------------------
create policy "owner: control total conversaciones"
on conversaciones for all
using (get_my_role() = 'owner')
with check (get_my_role() = 'owner');

create policy "admin: hilos cliente-admin de su organizacion"
on conversaciones for all
using (get_my_role() = 'admin' and tipo = 'cliente_admin' and organizacion_id = get_my_org_id())
with check (tipo = 'cliente_admin' and organizacion_id = get_my_org_id());

create policy "contador: hilos donde participa"
on conversaciones for select
using (get_my_role() = 'contador' and contador_id = auth.uid());

create policy "contador: crear hilos con sus clientes"
on conversaciones for insert
with check (get_my_role() = 'contador' and contador_id = auth.uid() and tipo = 'contador_cliente');

create policy "cliente: hilos donde participa"
on conversaciones for select
using (get_my_role() = 'cliente' and cliente_id = auth.uid());

create policy "cliente: crear hilos"
on conversaciones for insert
with check (get_my_role() = 'cliente' and cliente_id = auth.uid());


-- ------------------------------------------------------------
-- mensajes
-- ------------------------------------------------------------
create policy "owner: control total mensajes"
on mensajes for all
using (get_my_role() = 'owner')
with check (get_my_role() = 'owner');

create policy "participante: ver mensajes de mis conversaciones"
on mensajes for select
using (is_participante_conversacion(conversacion_id));

create policy "participante: enviar mensajes en mis conversaciones"
on mensajes for insert
with check (is_participante_conversacion(conversacion_id) and remitente_id = auth.uid());