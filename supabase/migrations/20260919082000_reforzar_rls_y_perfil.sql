drop policy if exists "admin: hilos cliente-admin de su organizacion" on public.conversaciones;
drop policy if exists "contador: hilos donde participa" on public.conversaciones;
drop policy if exists "contador: crear hilos con sus clientes" on public.conversaciones;
drop policy if exists "cliente: hilos donde participa" on public.conversaciones;
drop policy if exists "cliente: crear hilos" on public.conversaciones;
drop policy if exists "participante: ver mensajes de mis conversaciones" on public.mensajes;
drop policy if exists "participante: enviar mensajes en mis conversaciones" on public.mensajes;
drop policy if exists "usuario: actualizar mi propio perfil" on public.usuarios;

create policy "admin: hilos cliente-admin de su organizacion"
on public.conversaciones for select
to authenticated
using (
    get_my_role() = 'admin'
    and tipo = 'cliente_admin'
    and organizacion_id = get_my_org_id()
);

create policy "contador: hilos donde participa"
on public.conversaciones for select
to authenticated
using (
    get_my_role() = 'contador'
    and contador_id = auth.uid()
    and tipo = 'contador_cliente'
);

create policy "contador: crear hilos con sus clientes"
on public.conversaciones for insert
to authenticated
with check (
    get_my_role() = 'contador'
    and contador_id = auth.uid()
    and tipo = 'contador_cliente'
    and organizacion_id = get_my_org_id()
    and cliente_id in (
        select id from public.usuarios where contador_id = auth.uid() and organizacion_id = get_my_org_id()
    )
);

create policy "cliente: hilos donde participa"
on public.conversaciones for select
to authenticated
using (
    get_my_role() = 'cliente'
    and cliente_id = auth.uid()
);

create policy "cliente: crear hilos"
on public.conversaciones for insert
to authenticated
with check (
    get_my_role() = 'cliente'
    and cliente_id = auth.uid()
    and organizacion_id = get_my_org_id()
    and tipo = 'cliente_admin'
    and admin_id in (
        select id from public.usuarios where organizacion_id = get_my_org_id() and rol_id in (
            select id from public.roles where lower(nombre) = 'admin'
        )
    )
);

create policy "participante: ver mensajes de mis conversaciones"
on public.mensajes for select
to authenticated
using (is_participante_conversacion(conversacion_id));

create policy "participante: enviar mensajes en mis conversaciones"
on public.mensajes for insert
to authenticated
with check (
    is_participante_conversacion(conversacion_id)
    and remitente_id = auth.uid()
    and exists (
        select 1
        from public.conversaciones c
        where c.id = conversacion_id
          and c.organizacion_id = get_my_org_id()
    )
);

create policy "usuario: actualizar mi propio perfil"
on public.usuarios for update
to authenticated
using (id = auth.uid())
with check (
    id = auth.uid()
    and rol_id = (select rol_id from public.usuarios where id = auth.uid())
    and organizacion_id = (select organizacion_id from public.usuarios where id = auth.uid())
    and contador_id = (select contador_id from public.usuarios where id = auth.uid())
    and estatus_id = (select estatus_id from public.usuarios where id = auth.uid())
    and email = (select email from public.usuarios where id = auth.uid())
);
