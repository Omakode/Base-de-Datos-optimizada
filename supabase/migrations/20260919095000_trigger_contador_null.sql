create or replace function public.actualizar_contador_en_relaciones_v2()
returns trigger as $$
begin
    if old.contador_id is not distinct from new.contador_id then
        return new;
    end if;

    update public.actividades
    set contador_id = new.contador_id
    where cliente_id = new.id
      and contador_id is distinct from new.contador_id;

    update public.conversaciones
    set contador_id = new.contador_id
    where cliente_id = new.id
      and tipo = 'contador_cliente'
      and contador_id is distinct from new.contador_id;

    return new;
end;
$$ language plpgsql security definer set search_path = public;

drop trigger if exists trg_usuarios_contador_sync on public.usuarios;

create trigger trg_usuarios_contador_sync
after update of contador_id on public.usuarios
for each row
when (old.contador_id is distinct from new.contador_id)
execute function public.actualizar_contador_en_relaciones_v2();
