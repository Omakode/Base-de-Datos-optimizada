create or replace function public.validar_conversacion_participantes()
returns trigger as $$
declare
    v_cliente_organizacion uuid;
    v_contador_organizacion uuid;
    v_admin_organizacion uuid;
begin
    if new.tipo = 'contador_cliente' then
        if new.contador_id is null or new.admin_id is not null then
            raise exception 'Las conversaciones contador_cliente requieren contador_id y admin_id nulo';
        end if;

        select organizacion_id into v_cliente_organizacion
        from public.usuarios
        where id = new.cliente_id;

        if v_cliente_organizacion is null then
            raise exception 'El cliente de la conversación no existe';
        end if;

        if new.organizacion_id is distinct from v_cliente_organizacion then
            raise exception 'La organización de la conversación debe coincidir con la del cliente';
        end if;

        select organizacion_id into v_contador_organizacion
        from public.usuarios
        where id = new.contador_id;

        if v_contador_organizacion is null then
            raise exception 'El contador de la conversación no existe';
        end if;

        if v_contador_organizacion is distinct from v_cliente_organizacion then
            raise exception 'Cliente y contador deben pertenecer a la misma organización';
        end if;

        if (select contador_id from public.usuarios where id = new.cliente_id) is distinct from new.contador_id then
            raise exception 'El contador asignado a la conversación debe ser el contador actual del cliente';
        end if;

        return new;
    end if;

    if new.tipo = 'cliente_admin' then
        if new.admin_id is null or new.contador_id is not null then
            raise exception 'Las conversaciones cliente_admin requieren admin_id y contador_id nulo';
        end if;

        select organizacion_id into v_cliente_organizacion
        from public.usuarios
        where id = new.cliente_id;

        if v_cliente_organizacion is null then
            raise exception 'El cliente de la conversación no existe';
        end if;

        if new.organizacion_id is distinct from v_cliente_organizacion then
            raise exception 'La organización de la conversación debe coincidir con la del cliente';
        end if;

        select organizacion_id into v_admin_organizacion
        from public.usuarios
        where id = new.admin_id;

        if v_admin_organizacion is null then
            raise exception 'El administrador de la conversación no existe';
        end if;

        if v_admin_organizacion is distinct from v_cliente_organizacion then
            raise exception 'Cliente y administrador deben pertenecer a la misma organización';
        end if;

        return new;
    end if;

    raise exception 'Tipo de conversación no permitido';
end;
$$ language plpgsql security definer set search_path = public;

drop trigger if exists trg_validar_conversacion_participantes on public.conversaciones;

create trigger trg_validar_conversacion_participantes
before insert or update on public.conversaciones
for each row
execute function public.validar_conversacion_participantes();
