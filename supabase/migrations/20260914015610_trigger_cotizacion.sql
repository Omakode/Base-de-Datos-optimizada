-- ============================================================
-- 04 — TRIGGER: cotizacion -> actividad
-- Reemplaza: 20260815084740_trigger.sql (sin cambios)
-- Al pasar cotizaciones.estatus_id a "aceptada", crea automáticamente
-- la fila correspondiente en "actividades", asignada al contador que
-- ya tiene el cliente (usuarios.contador_id).
-- ============================================================

create or replace function fn_convertir_cotizacion_en_actividad()
returns trigger as $$
declare
    v_estatus_aceptada_id            uuid;
    v_estatus_actividad_pendiente_id uuid;
    v_contador_id                    uuid;
begin
    select id into v_estatus_aceptada_id
    from estatus_cotizacion
    where lower(nombre) = 'aceptada';

    if new.estatus_id is distinct from v_estatus_aceptada_id then
        return new;
    end if;

    if old.estatus_id is not distinct from v_estatus_aceptada_id then
        return new;
    end if;

    if exists (select 1 from actividades where cotizacion_id = new.id) then
        return new;
    end if;

    select contador_id into v_contador_id
    from usuarios
    where id = new.cliente_id;

    if v_contador_id is null then
        raise exception
            'El cliente % no tiene contador asignado, no se puede aceptar la cotizacion %',
            new.cliente_id, new.id;
    end if;

    select id into v_estatus_actividad_pendiente_id
    from estatus_actividad
    where lower(nombre) = 'pendiente';

    insert into actividades (
        organizacion_id, cotizacion_id, cliente_id, contador_id,
        titulo, descripcion, precio, estatus_id
    ) values (
        new.organizacion_id, new.id, new.cliente_id, v_contador_id,
        new.titulo, new.descripcion, new.precio, v_estatus_actividad_pendiente_id
    );

    return new;
end;
$$ language plpgsql security definer set search_path = public;

create trigger trg_cotizacion_aceptada
after update of estatus_id on cotizaciones
for each row
execute function fn_convertir_cotizacion_en_actividad();