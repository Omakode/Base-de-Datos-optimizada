create unique index if not exists ux_roles_nombre
    on public.roles (lower(nombre));

create unique index if not exists ux_estatus_usuarios_nombre
    on public.estatus_usuarios (lower(nombre));

create unique index if not exists ux_estatus_cotizacion_nombre
    on public.estatus_cotizacion (lower(nombre));

create unique index if not exists ux_estatus_actividad_nombre
    on public.estatus_actividad (lower(nombre));

create unique index if not exists ux_regimenes_fiscales_nombre
    on public.regimenes_fiscales (lower(nombre));

create unique index if not exists ux_especialidad_contador_nombre
    on public.especialidad_contador (lower(nombre));

create unique index if not exists ux_categorias_nombre
    on public.categorias (lower(nombre));

create unique index if not exists ux_catalogo_actividades_nombre
    on public.catalogo_actividades (lower(nombre));

create unique index if not exists ux_categoria_documentos_nombre
    on public.categoria_documentos (lower(nombre));

create unique index if not exists ux_lista_actividades_relacion
    on public.lista_actividades (categoria_id, catalogo_actividad_id);

create unique index if not exists ux_organizaciones_nombre
    on public.organizaciones (lower(nombre));

insert into public.organizaciones (nombre)
values
    ('Despacho de Ali'),
    ('Despacho de Gilberto'),
    ('Despacho de Wicho')
on conflict (lower(nombre)) do nothing;

insert into public.roles (nombre)
values
    ('owner'),
    ('admin'),
    ('contador'),
    ('cliente')
on conflict (lower(nombre)) do nothing;

insert into public.estatus_cotizacion (nombre)
values
    ('pendiente'),
    ('aceptada'),
    ('rechazada'),
    ('cancelada')
on conflict (lower(nombre)) do nothing;

insert into public.estatus_actividad (nombre)
values
    ('pendiente'),
    ('en_proceso'),
    ('completada'),
    ('cancelada')
on conflict (lower(nombre)) do nothing;

insert into public.estatus_usuarios (nombre)
values
    ('activo'),
    ('inactivo')
on conflict (lower(nombre)) do nothing;

insert into public.especialidad_contador (nombre)
values
    ('Declaración anual persona física'),
    (' Declaración anual persona moral'),
    ('Declaración mensual IVA'),
    ('Cálculo y pago de nómina'),
    ('IMSS / INFONAVIT'),
    ('Alta y baja en el SAT'),
    ('Cambio de régimen fiscal'),
    ('Contabilidad general'),
    ('Facturación electrónica (CFDI)'),
    ('Auditoría fiscal')
on conflict (lower(nombre)) do nothing;

insert into public.regimenes_fiscales (nombre)
values
    ('Sueldos y Salarios e Ingresos Asimilados a Salarios'),
    ('Actividades Empresariales y Profesionales'),
    ('Régimen Simplificado de Confianza (RESICO) - Persona Física'),
    ('Régimen Simplificado de Confianza (RESICO) - Persona Moral'),
    ('Incorporación Fiscal'),
    ('Arrendamiento y en General por Otorgar el Uso o Goce Temporal de Bienes Inmuebles'),
    ('Enajenación de Bienes'),
    ('Adquisición de Bienes'),
    ('Intereses'),
    ('Dividendos y en General por las Ganancias Distribuidas por Personas Morales'),
    ('Demás Ingresos'),
    ('Régimen General de Ley - Persona Moral'),
    ('Personas Morales con Fines no Lucrativos'),
    ('Sin obligaciones fiscales')
on conflict (lower(nombre)) do nothing;

insert into public.categorias (nombre)
values
    ('Fiscal'),
    ('Laboral'),
    ('Contable'),
    ('Constitución y trámites'),
    ('Facturación')
on conflict (lower(nombre)) do nothing;

insert into public.catalogo_actividades (nombre, activo)
values
    ('Declaración anual persona física', true),
    ('Declaración anual persona moral', true),
    ('Declaración mensual IVA', true),
    ('Declaración mensual ISR', true),
    ('Declaración informativa', true),
    ('Opinión de cumplimiento SAT', true),
    ('Constancia de situación fiscal', true),
    ('Cambio de régimen fiscal', true),
    ('Cálculo de nómina', true),
    ('Alta de empleado IMSS', true),
    ('Baja de empleado IMSS', true),
    ('Pago de cuotas IMSS / INFONAVIT', true),
    ('Liquidación de empleado', true),
    ('Contabilidad mensual', true),
    ('Cierre contable anual', true),
    ('Conciliación bancaria', true),
    ('Estados financieros', true),
    ('Constitución de empresa (S.A. de C.V.)', true),
    ('Alta en el SAT persona física', true),
    ('Alta en el SAT persona moral', true),
    ('Trámite de e.firma (FIEL)', true),
    ('Renovación de e.firma', true),
    ('Emisión de facturas CFDI', true),
    ('Cancelación de facturas CFDI', true),
    ('Configuración de sello digital (CSD)', true)
on conflict (lower(nombre)) do nothing;

insert into public.lista_actividades (categoria_id, catalogo_actividad_id)
select c.id, a.id
from public.categorias c
join public.catalogo_actividades a on true
where
    (lower(c.nombre) = 'fiscal' and lower(a.nombre) in (
        'declaración anual persona física',
        'declaración anual persona moral',
        'declaración mensual iva',
        'declaración mensual isr',
        'declaración informativa',
        'opinión de cumplimiento sat',
        'constancia de situación fiscal',
        'cambio de régimen fiscal'
    ))
    or (lower(c.nombre) = 'laboral' and lower(a.nombre) in (
        'cálculo de nómina',
        'alta de empleado imss',
        'baja de empleado imss',
        'pago de cuotas imss / infonavit',
        'liquidación de empleado'
    ))
    or (lower(c.nombre) = 'contable' and lower(a.nombre) in (
        'contabilidad mensual',
        'cierre contable anual',
        'conciliación bancaria',
        'estados financieros'
    ))
    or (lower(c.nombre) = 'constitución y trámites' and lower(a.nombre) in (
        'constitución de empresa (s.a. de c.v.)',
        'alta en el sat persona física',
        'alta en el sat persona moral',
        'trámite de e.firma (fiel)',
        'renovación de e.firma'
    ))
    or (lower(c.nombre) = 'facturación' and lower(a.nombre) in (
        'emisión de facturas cfdi',
        'cancelación de facturas cfdi',
        'configuración de sello digital (csd)'
    ))
on conflict (categoria_id, catalogo_actividad_id) do nothing;

insert into public.categoria_documentos (nombre)
values
    ('Identificación oficial (INE / Pasaporte)'),
    ('CURP'),
    ('RFC / Constancia de situación fiscal'),
    ('Comprobante de domicilio'),
    ('Estado de cuenta bancario'),
    ('Factura / CFDI'),
    ('Acta constitutiva'),
    ('Poder notarial'),
    ('Comprobante de ingresos'),
    ('Declaración fiscal'),
    ('Nómina / Recibo de pago'),
    ('Contrato'),
    ('Otro')
on conflict (lower(nombre)) do nothing;
