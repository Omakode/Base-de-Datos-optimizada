insert into public.cotizaciones (
    id,
    organizacion_id,
    titulo,
    descripcion,
    precio,
    cliente_id,
    estatus_id,
    actividad_catalogo_id
)
values
    (
        'a3111111-1111-4111-8111-111111111111'::uuid,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        'Declaración anual 2025',
        'Preparación y presentación de la declaración anual.',
        4500.00,
        '78f4f1e1-ef59-4bc2-8f4a-4824b2afed07'::uuid,
        (select id from public.estatus_cotizacion where lower(nombre) = 'pendiente' limit 1),
        (select la.id from public.lista_actividades la join public.catalogo_actividades ca on ca.id = la.catalogo_actividad_id where lower(ca.nombre) = lower('Declaración anual persona física') limit 1)
    ),
    (
        'a3222222-2222-4222-8222-222222222222'::uuid,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        'Contabilidad mensual',
        'Servicio de contabilidad correspondiente al mes actual.',
        3200.00,
        'b9cd15a4-49ee-44df-abdf-e6c587037c39'::uuid,
        (select id from public.estatus_cotizacion where lower(nombre) = 'aceptada' limit 1),
        (select la.id from public.lista_actividades la join public.catalogo_actividades ca on ca.id = la.catalogo_actividad_id where lower(ca.nombre) = lower('Contabilidad mensual') limit 1)
    ),
    (
        'a3333333-3333-4333-8333-333333333333'::uuid,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        'Opinión de cumplimiento SAT',
        'Obtención y revisión de la opinión de cumplimiento fiscal.',
        1800.00,
        '78f4f1e1-ef59-4bc2-8f4a-4824b2afed07'::uuid,
        (select id from public.estatus_cotizacion where lower(nombre) = 'rechazada' limit 1),
        (select la.id from public.lista_actividades la join public.catalogo_actividades ca on ca.id = la.catalogo_actividad_id where lower(ca.nombre) = lower('Opinión de cumplimiento SAT') limit 1)
    )
on conflict (id) do nothing;

insert into public.actividades (
    id,
    organizacion_id,
    cotizacion_id,
    cliente_id,
    contador_id,
    titulo,
    descripcion,
    precio,
    estatus_id
)
values
    (
        'b3111111-1111-4111-8111-111111111111'::uuid,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        'a3111111-1111-4111-8111-111111111111'::uuid,
        '78f4f1e1-ef59-4bc2-8f4a-4824b2afed07'::uuid,
        '401838ec-6617-471e-a552-bed05104f12e'::uuid,
        'Revisión de información fiscal',
        'Revisión inicial de documentos para la declaración anual.',
        4500.00,
        (select id from public.estatus_actividad where lower(nombre) = 'en_proceso' limit 1)
    ),
    (
        'b3222222-2222-4222-8222-222222222222'::uuid,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        'a3222222-2222-4222-8222-222222222222'::uuid,
        'b9cd15a4-49ee-44df-abdf-e6c587037c39'::uuid,
        '401838ec-6617-471e-a552-bed05104f12e'::uuid,
        'Registro contable mensual',
        'Captura y conciliación de operaciones del periodo.',
        3200.00,
        (select id from public.estatus_actividad where lower(nombre) = 'pendiente' limit 1)
    )
on conflict (id) do nothing;

insert into public.carpetas (
    id,
    organizacion_id,
    cliente_id,
    nombre
)
values
    (
        'c3111111-1111-4111-8111-111111111111'::uuid,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        '78f4f1e1-ef59-4bc2-8f4a-4824b2afed07'::uuid,
        'Documentos personales'
    ),
    (
        'c3222222-2222-4222-8222-222222222222'::uuid,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        'b9cd15a4-49ee-44df-abdf-e6c587037c39'::uuid,
        'Documentos fiscales'
    )
on conflict (id) do nothing;

insert into public.documentos (
    id,
    organizacion_id,
    actividad_id,
    carpeta_id,
    cliente_id,
    subido_por_id,
    nombre_archivo,
    ruta_archivo,
    categoria_documento_id
)
values
    (
        'd3111111-1111-4111-8111-111111111111'::uuid,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        'b3111111-1111-4111-8111-111111111111'::uuid,
        null,
        '78f4f1e1-ef59-4bc2-8f4a-4824b2afed07'::uuid,
        '78f4f1e1-ef59-4bc2-8f4a-4824b2afed07'::uuid,
        'declaracion_anual_2025.pdf',
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa/78f4f1e1-ef59-4bc2-8f4a-4824b2afed07/declaracion_anual_2025.pdf',
        (select id from public.categoria_documentos where lower(nombre) = lower('Declaración fiscal') limit 1)
    ),
    (
        'd3222222-2222-4222-8222-222222222222'::uuid,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        null,
        'c3222222-2222-4222-8222-222222222222'::uuid,
        'b9cd15a4-49ee-44df-abdf-e6c587037c39'::uuid,
        'b9cd15a4-49ee-44df-abdf-e6c587037c39'::uuid,
        'constancia_situacion_fiscal.pdf',
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa/b9cd15a4-49ee-44df-abdf-e6c587037c39/constancia_situacion_fiscal.pdf',
        (select id from public.categoria_documentos where lower(nombre) = lower('RFC / Constancia de situación fiscal') limit 1)
    ),
    (
        'd3333333-3333-4333-8333-333333333333'::uuid,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        'b3222222-2222-4222-8222-222222222222'::uuid,
        null,
        'b9cd15a4-49ee-44df-abdf-e6c587037c39'::uuid,
        '401838ec-6617-471e-a552-bed05104f12e'::uuid,
        'balanza_mensual.xlsx',
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa/b9cd15a4-49ee-44df-abdf-e6c587037c39/balanza_mensual.xlsx',
        (select id from public.categoria_documentos where lower(nombre) = lower('Estado de cuenta bancario') limit 1)
    )
on conflict (id) do nothing;

insert into public.conversaciones (
    id,
    organizacion_id,
    tipo,
    cliente_id,
    contador_id,
    admin_id,
    cotizacion_id,
    actividad_id
)
values
    (
        'e3111111-1111-4111-8111-111111111111'::uuid,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        'cliente_admin',
        '78f4f1e1-ef59-4bc2-8f4a-4824b2afed07'::uuid,
        null,
        '5e0642e0-c162-4e3b-a268-ea4a9dfcd9f7'::uuid,
        'a3111111-1111-4111-8111-111111111111'::uuid,
        'b3111111-1111-4111-8111-111111111111'::uuid
    ),
    (
        'e3222222-2222-4222-8222-222222222222'::uuid,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        'cliente_admin',
        'b9cd15a4-49ee-44df-abdf-e6c587037c39'::uuid,
        null,
        '5e0642e0-c162-4e3b-a268-ea4a9dfcd9f7'::uuid,
        'a3222222-2222-4222-8222-222222222222'::uuid,
        null
    ),
    (
        'e3333333-3333-4333-8333-333333333333'::uuid,
        '1e9921e3-cad5-4cc1-936d-72db1f1ce5aa'::uuid,
        'cliente_admin',
        'b9cd15a4-49ee-44df-abdf-e6c587037c39'::uuid,
        null,
        '5e0642e0-c162-4e3b-a268-ea4a9dfcd9f7'::uuid,
        'a3222222-2222-4222-8222-222222222222'::uuid,
        'b3222222-2222-4222-8222-222222222222'::uuid
    )
on conflict (id) do nothing;

insert into public.mensajes (
    id,
    conversacion_id,
    remitente_id,
    contenido
)
values
    (
        'f3111111-1111-4111-8111-111111111111'::uuid,
        'e3111111-1111-4111-8111-111111111111'::uuid,
        '78f4f1e1-ef59-4bc2-8f4a-4824b2afed07'::uuid,
        'Comparto la documentación para iniciar la declaración anual.'
    ),
    (
        'f3222222-2222-4222-8222-222222222222'::uuid,
        'e3111111-1111-4111-8111-111111111111'::uuid,
        '401838ec-6617-471e-a552-bed05104f12e'::uuid,
        'Recibido. Revisaré los documentos y te confirmaré si falta algo.'
    ),
    (
        'f3333333-3333-4333-8333-333333333333'::uuid,
        'e3222222-2222-4222-8222-222222222222'::uuid,
        '5e0642e0-c162-4e3b-a268-ea4a9dfcd9f7'::uuid,
        'La cotización de contabilidad mensual quedó enviada.'
    ),
    (
        'f4444444-4444-4444-8444-444444444444'::uuid,
        'e3333333-3333-4333-8333-333333333333'::uuid,
        'b9cd15a4-49ee-44df-abdf-e6c587037c39'::uuid,
        'Quedo atento a la revisión de la balanza mensual.'
    )
on conflict (id) do nothing;
