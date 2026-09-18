-- ============================================================
-- 03 — SEED (consolidado)
-- Reemplaza: 20260813055122_seed_pruebas.sql
--            20260908201546_seed_catalagos.sql
-- ============================================================

insert into public.organizaciones (nombre) values
    ('Despacho de Ali'),
    ('Despacho de Gilberto'),
    ('Despacho de Wicho');

insert into public.roles (nombre) values
    ('owner'),
    ('admin'),
    ('contador'),
    ('cliente');

insert into public.estatus_cotizacion (nombre) values
    ('pendiente'),
    ('aceptada'),
    ('rechazada'),
    ('cancelada');

insert into public.estatus_actividad (nombre) values
    ('pendiente'),
    ('en_proceso'),
    ('completada'),
    ('cancelada');

insert into public.estatus_usuarios (nombre) values
    ('activo'),
    ('inactivo');


-- ------------------------------------------------------------
-- especialidad_contador
-- ------------------------------------------------------------
insert into public.especialidad_contador (nombre) values
    ('Declaración anual persona física'),
    ('Declaración anual persona moral'),
    ('Declaración mensual IVA'),
    ('Cálculo y pago de nómina'),
    ('IMSS / INFONAVIT'),
    ('Alta y baja en el SAT'),
    ('Cambio de régimen fiscal'),
    ('Contabilidad general'),
    ('Facturación electrónica (CFDI)'),
    ('Auditoría fiscal');


-- ------------------------------------------------------------
-- regimenes_fiscales (catálogo oficial SAT)
-- ------------------------------------------------------------
insert into public.regimenes_fiscales (nombre) values
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
    ('Sin obligaciones fiscales');


-- ------------------------------------------------------------
-- categorias
-- ------------------------------------------------------------
insert into public.categorias (nombre) values
    ('Fiscal'),
    ('Laboral'),
    ('Contable'),
    ('Constitución y trámites'),
    ('Facturación');


-- ------------------------------------------------------------
-- catalogo_actividades
-- ------------------------------------------------------------
insert into public.catalogo_actividades (nombre, activo) values
    -- Fiscal
    ('Declaración anual persona física',        true),
    ('Declaración anual persona moral',         true),
    ('Declaración mensual IVA',                 true),
    ('Declaración mensual ISR',                 true),
    ('Declaración informativa',                 true),
    ('Opinión de cumplimiento SAT',             true),
    ('Constancia de situación fiscal',          true),
    ('Cambio de régimen fiscal',                true),
    -- Laboral
    ('Cálculo de nómina',                       true),
    ('Alta de empleado IMSS',                   true),
    ('Baja de empleado IMSS',                   true),
    ('Pago de cuotas IMSS / INFONAVIT',         true),
    ('Liquidación de empleado',                 true),
    -- Contable
    ('Contabilidad mensual',                    true),
    ('Cierre contable anual',                   true),
    ('Conciliación bancaria',                   true),
    ('Estados financieros',                     true),
    -- Constitución y trámites
    ('Constitución de empresa (S.A. de C.V.)',  true),
    ('Alta en el SAT persona física',           true),
    ('Alta en el SAT persona moral',            true),
    ('Trámite de e.firma (FIEL)',               true),
    ('Renovación de e.firma',                   true),
    -- Facturación
    ('Emisión de facturas CFDI',                true),
    ('Cancelación de facturas CFDI',            true),
    ('Configuración de sello digital (CSD)',    true);


-- ------------------------------------------------------------
-- lista_actividades (relación categoria <-> actividad)
-- ------------------------------------------------------------
insert into public.lista_actividades (categoria_id, catalogo_actividad_id)
select c.id, a.id
from public.categorias c, public.catalogo_actividades a
where
    (c.nombre = 'Fiscal' and a.nombre in (
        'Declaración anual persona física',
        'Declaración anual persona moral',
        'Declaración mensual IVA',
        'Declaración mensual ISR',
        'Declaración informativa',
        'Opinión de cumplimiento SAT',
        'Constancia de situación fiscal',
        'Cambio de régimen fiscal'
    ))
    or
    (c.nombre = 'Laboral' and a.nombre in (
        'Cálculo de nómina',
        'Alta de empleado IMSS',
        'Baja de empleado IMSS',
        'Pago de cuotas IMSS / INFONAVIT',
        'Liquidación de empleado'
    ))
    or
    (c.nombre = 'Contable' and a.nombre in (
        'Contabilidad mensual',
        'Cierre contable anual',
        'Conciliación bancaria',
        'Estados financieros'
    ))
    or
    (c.nombre = 'Constitución y trámites' and a.nombre in (
        'Constitución de empresa (S.A. de C.V.)',
        'Alta en el SAT persona física',
        'Alta en el SAT persona moral',
        'Trámite de e.firma (FIEL)',
        'Renovación de e.firma'
    ))
    or
    (c.nombre = 'Facturación' and a.nombre in (
        'Emisión de facturas CFDI',
        'Cancelación de facturas CFDI',
        'Configuración de sello digital (CSD)'
    ));


-- ------------------------------------------------------------
-- categoria_documentos
-- ------------------------------------------------------------
insert into public.categoria_documentos (nombre) values
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
    ('Otro');