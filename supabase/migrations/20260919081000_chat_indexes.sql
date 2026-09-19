create index if not exists idx_conversaciones_cliente_id
    on public.conversaciones (cliente_id);

create index if not exists idx_conversaciones_contador_id
    on public.conversaciones (contador_id);

create index if not exists idx_conversaciones_admin_id
    on public.conversaciones (admin_id);

create index if not exists idx_conversaciones_organizacion_id
    on public.conversaciones (organizacion_id);

create index if not exists idx_mensajes_conversacion_fecha_envio
    on public.mensajes (conversacion_id, fecha_envio);

create index if not exists idx_mensajes_remitente_id
    on public.mensajes (remitente_id);
