create or replace function public.storage_documentos_autorizado(p_name text, p_bucket_id text)
returns boolean
language sql
security definer
set search_path = public
as $$
    select (
        get_my_role() = 'owner'
        or (
            get_my_role() = 'admin'
            and exists (
                select 1
                from public.documentos d
                where d.ruta_archivo = p_name
                  and d.organizacion_id = get_my_org_id()
            )
        )
        or (
            get_my_role() = 'contador'
            and exists (
                select 1
                from public.documentos d
                join public.actividades a on a.id = d.actividad_id
                where d.ruta_archivo = p_name
                  and a.contador_id = auth.uid()
            )
        )
        or (
            get_my_role() = 'cliente'
            and exists (
                select 1
                from public.documentos d
                where d.ruta_archivo = p_name
                  and d.cliente_id = auth.uid()
            )
        )
    )
    and p_bucket_id = 'documentos';
$$;

drop policy if exists "documentos: owner total" on storage.objects;
drop policy if exists "documentos: admin org" on storage.objects;
drop policy if exists "documentos: contador actividades" on storage.objects;
drop policy if exists "documentos: cliente mis documentos" on storage.objects;
drop policy if exists "documentos: insert solo si existe registro valido" on storage.objects;
drop policy if exists "documentos: update delete por documento" on storage.objects;
drop policy if exists "documentos: delete por documento" on storage.objects;

create policy "documentos_bucket: owner total"
on storage.objects for all
to authenticated
using (
    bucket_id = 'documentos'
    and get_my_role() = 'owner'
)
with check (
    bucket_id = 'documentos'
    and get_my_role() = 'owner'
);

create policy "documentos_bucket: admin org"
on storage.objects for select
to authenticated
using (
    bucket_id = 'documentos'
    and public.storage_documentos_autorizado(name, bucket_id)
    and get_my_role() = 'admin'
);

create policy "documentos_bucket: contador actividades"
on storage.objects for select
to authenticated
using (
    bucket_id = 'documentos'
    and public.storage_documentos_autorizado(name, bucket_id)
    and get_my_role() = 'contador'
);

create policy "documentos_bucket: cliente mis documentos"
on storage.objects for select
to authenticated
using (
    bucket_id = 'documentos'
    and public.storage_documentos_autorizado(name, bucket_id)
    and get_my_role() = 'cliente'
);

create policy "documentos_bucket: insert con documento valido"
on storage.objects for insert
to authenticated
with check (
    bucket_id = 'documentos'
    and (
        get_my_role() = 'owner'
        or (
            get_my_role() = 'admin'
            and exists (
                select 1
                from public.documentos d
                where d.ruta_archivo = name
                  and d.organizacion_id = get_my_org_id()
            )
        )
        or (
            get_my_role() = 'contador'
            and exists (
                select 1
                from public.documentos d
                join public.actividades a on a.id = d.actividad_id
                where d.ruta_archivo = name
                  and a.contador_id = auth.uid()
            )
        )
        or (
            get_my_role() = 'cliente'
            and exists (
                select 1
                from public.documentos d
                where d.ruta_archivo = name
                  and d.cliente_id = auth.uid()
            )
        )
    )
);

create policy "documentos_bucket: update por documento"
on storage.objects for update
to authenticated
using (
    bucket_id = 'documentos'
    and public.storage_documentos_autorizado(name, bucket_id)
)
with check (
    bucket_id = 'documentos'
    and public.storage_documentos_autorizado(name, bucket_id)
);

create policy "documentos_bucket: delete por documento"
on storage.objects for delete
to authenticated
using (
    bucket_id = 'documentos'
    and public.storage_documentos_autorizado(name, bucket_id)
);
