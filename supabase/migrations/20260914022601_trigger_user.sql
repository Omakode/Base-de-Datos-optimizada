-- ============================================================
-- 05 — TRIGGER: nuevo usuario (auth.users -> public.usuarios)
-- Reemplaza: 20260902024413_trigger_new_user.sql
--            20260902030614_actualizar_trigger_usuario.sql
--            20260902031744_actualizar_trigger_usuario2.sql
--            20260902032734_correccion_new_user_trigger.sql (la funcion; el ALTER ya va en 01_schema.sql)
--            20260902033456_correccion_new_user_trigger2.sql
--            20260902141830_correccion_new_user_trigger3.sql (identica a la anterior, sin cambios reales)
--
-- Bugs de las versiones intermedias ya corregidos aqui:
--   - "estatus_usuario" -> "estatus_usuarios" (typo de tabla)
--   - cast invalido (new.raw_user_meta_data->>'rol_id', '')::uuid -> corregido
--   - "refimen_fiscal_id" -> "regimen_fiscal_id" (typo de columna)
-- ============================================================

create or replace function public.nuevo_usuario()
returns trigger as $$
declare
  estatus_id uuid;
begin
  select id into estatus_id
  from public.estatus_usuarios
  where lower(nombre) = 'activo'
  limit 1;

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
    organizacion_id
  )
  values (
    new.id,
    new.raw_user_meta_data->>'nombre',
    new.raw_user_meta_data->>'apellido_paterno',
    new.raw_user_meta_data->>'apellido_materno',
    new.email,
    NULLIF(new.raw_user_meta_data->>'rfc', ''),
    estatus_id,
    NULLIF(new.raw_user_meta_data->>'regimen_fiscal_id', '')::uuid,
    (new.raw_user_meta_data->>'rol_id')::uuid,
    (NULLIF(new.raw_user_meta_data->>'contador_id', ''))::uuid,
    (NULLIF(new.raw_user_meta_data->>'organizacion_id', ''))::uuid
  )
  on conflict (id) do nothing;

  return new;
end;
$$ language plpgsql security definer set search_path = public;

create or replace trigger usuario_nuevo
  after insert on auth.users
  for each row execute procedure public.nuevo_usuario();