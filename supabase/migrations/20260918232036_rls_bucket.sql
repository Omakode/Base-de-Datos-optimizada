insert into storage.buckets (id, name, public)
values ('documentos', 'documentos', false)
on conflict (id) do nothing;

create policy "documentos: owner total"
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

create policy "documentos: admin org"
on storage.objects for select
to authenticated
using (
    bucket_id = 'documentos'
    and get_my_role() = 'admin'
    and exists (
        select 1
        from public.documentos d
        where d.organizacion_id = get_my_org_id()
          and d.ruta_archivo = storage.objects.name
    )
);

create policy "documentos: contador actividades"
on storage.objects for select
to authenticated
using (
    bucket_id = 'documentos'
    and get_my_role() = 'contador'
    and exists (
        select 1
        from public.documentos d
        join public.actividades a on a.id = d.actividad_id
        where d.ruta_archivo = storage.objects.name
          and a.contador_id = auth.uid()
    )
);

create policy "documentos: cliente mis documentos"
on storage.objects for select
to authenticated
using (
    bucket_id = 'documentos'
    and get_my_role() = 'cliente'
    and exists (
        select 1
        from public.documentos d
        where d.ruta_archivo = storage.objects.name
          and d.cliente_id = auth.uid()
    )
);

create policy "documentos: insert bucket por rol"
on storage.objects for insert
to authenticated
with check (
    bucket_id = 'documentos'
    and get_my_role() in ('owner', 'admin', 'contador', 'cliente')
);

create policy "documentos: update delete por documento"
on storage.objects for update
to authenticated
using (
    bucket_id = 'documentos'
    and exists (
        select 1
        from public.documentos d
        where d.ruta_archivo = storage.objects.name
          and (
              get_my_role() = 'owner'
              or (
                  get_my_role() = 'admin'
                  and d.organizacion_id = get_my_org_id()
              )
              or (
                  get_my_role() = 'contador'
                  and exists (
                      select 1
                      from public.actividades a
                      where a.id = d.actividad_id
                        and a.contador_id = auth.uid()
                  )
              )
              or (
                  get_my_role() = 'cliente'
                  and d.cliente_id = auth.uid()
              )
          )
    )
)
with check (
    bucket_id = 'documentos'
    and exists (
        select 1
        from public.documentos d
        where d.ruta_archivo = storage.objects.name
          and (
              get_my_role() = 'owner'
              or (
                  get_my_role() = 'admin'
                  and d.organizacion_id = get_my_org_id()
              )
              or (
                  get_my_role() = 'contador'
                  and exists (
                      select 1
                      from public.actividades a
                      where a.id = d.actividad_id
                        and a.contador_id = auth.uid()
                  )
              )
              or (
                  get_my_role() = 'cliente'
                  and d.cliente_id = auth.uid()
              )
          )
    )
);

create policy "documentos: delete por documento"
on storage.objects for delete
to authenticated
using (
    bucket_id = 'documentos'
    and exists (
        select 1
        from public.documentos d
        where d.ruta_archivo = storage.objects.name
          and (
              get_my_role() = 'owner'
              or (
                  get_my_role() = 'admin'
                  and d.organizacion_id = get_my_org_id()
              )
              or (
                  get_my_role() = 'contador'
                  and exists (
                      select 1
                      from public.actividades a
                      where a.id = d.actividad_id
                        and a.contador_id = auth.uid()
                  )
              )
              or (
                  get_my_role() = 'cliente'
                  and d.cliente_id = auth.uid()
              )
          )
    )
);