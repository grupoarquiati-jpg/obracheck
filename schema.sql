-- Esquema base para ObraCheck (PostgreSQL)

CREATE TABLE usuarios (
  id BIGSERIAL PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  correo VARCHAR(180) UNIQUE NOT NULL,
  contrasena_hash TEXT NOT NULL,
  rol VARCHAR(20) NOT NULL CHECK (rol IN ('administrador', 'supervisor')),
  fecha_creacion TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE obras (
  id BIGSERIAL PRIMARY KEY,
  nombre_obra VARCHAR(180) NOT NULL,
  direccion TEXT,
  cliente VARCHAR(140),
  fecha_inicio DATE,
  fecha_fin_estimada DATE,
  estado VARCHAR(20) NOT NULL DEFAULT 'activa' CHECK (estado IN ('activa', 'pausada', 'cerrada'))
);

CREATE TABLE trabajadores (
  id BIGSERIAL PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  telefono VARCHAR(30),
  especialidad VARCHAR(80),
  salario_diario NUMERIC(12,2) NOT NULL CHECK (salario_diario >= 0),
  fecha_registro TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE asistencia (
  id BIGSERIAL PRIMARY KEY,
  trabajador_id BIGINT NOT NULL REFERENCES trabajadores(id),
  obra_id BIGINT NOT NULL REFERENCES obras(id),
  fecha DATE NOT NULL,
  hora_entrada TIMESTAMPTZ,
  hora_salida TIMESTAMPTZ,
  gps_latitud NUMERIC(10,7),
  gps_longitud NUMERIC(10,7),
  foto_url TEXT,
  horas_trabajadas NUMERIC(6,2) GENERATED ALWAYS AS (
    CASE
      WHEN hora_entrada IS NOT NULL AND hora_salida IS NOT NULL THEN EXTRACT(EPOCH FROM (hora_salida - hora_entrada))/3600
      ELSE NULL
    END
  ) STORED,
  CHECK (hora_salida IS NULL OR hora_entrada IS NOT NULL)
);

CREATE TABLE pagos (
  id BIGSERIAL PRIMARY KEY,
  trabajador_id BIGINT NOT NULL REFERENCES trabajadores(id),
  obra_id BIGINT NOT NULL REFERENCES obras(id),
  dias_trabajados INTEGER NOT NULL CHECK (dias_trabajados >= 0),
  monto_total NUMERIC(12,2) NOT NULL CHECK (monto_total >= 0),
  fecha_pago DATE,
  estado_pago VARCHAR(20) NOT NULL DEFAULT 'pendiente' CHECK (estado_pago IN ('pendiente', 'pagado', 'cancelado'))
);

CREATE TABLE materiales (
  id BIGSERIAL PRIMARY KEY,
  obra_id BIGINT NOT NULL REFERENCES obras(id),
  nombre_material VARCHAR(140) NOT NULL,
  cantidad NUMERIC(12,2) NOT NULL CHECK (cantidad >= 0),
  unidad VARCHAR(20) NOT NULL,
  costo_unitario NUMERIC(12,2) NOT NULL CHECK (costo_unitario >= 0),
  fecha_registro TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE uso_material (
  id BIGSERIAL PRIMARY KEY,
  material_id BIGINT NOT NULL REFERENCES materiales(id),
  obra_id BIGINT NOT NULL REFERENCES obras(id),
  cantidad_usada NUMERIC(12,2) NOT NULL CHECK (cantidad_usada > 0),
  gps_latitud NUMERIC(10,7),
  gps_longitud NUMERIC(10,7),
  foto_url TEXT,
  fecha TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE avances (
  id BIGSERIAL PRIMARY KEY,
  obra_id BIGINT NOT NULL REFERENCES obras(id),
  descripcion TEXT NOT NULL,
  porcentaje_avance NUMERIC(5,2) NOT NULL CHECK (porcentaje_avance >= 0 AND porcentaje_avance <= 100),
  gps_latitud NUMERIC(10,7),
  gps_longitud NUMERIC(10,7),
  foto_url TEXT,
  fecha TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE fotos (
  id BIGSERIAL PRIMARY KEY,
  obra_id BIGINT NOT NULL REFERENCES obras(id),
  avance_id BIGINT REFERENCES avances(id),
  url_foto TEXT NOT NULL,
  descripcion TEXT,
  fecha TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE presupuestos (
  id BIGSERIAL PRIMARY KEY,
  obra_id BIGINT NOT NULL REFERENCES obras(id),
  descripcion TEXT NOT NULL,
  cantidad NUMERIC(12,2) NOT NULL CHECK (cantidad >= 0),
  precio_unitario NUMERIC(12,2) NOT NULL CHECK (precio_unitario >= 0),
  subtotal NUMERIC(12,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED
);

CREATE INDEX idx_asistencia_obra_fecha ON asistencia (obra_id, fecha);
CREATE INDEX idx_avances_obra_fecha ON avances (obra_id, fecha);
CREATE INDEX idx_uso_material_obra_fecha ON uso_material (obra_id, fecha);
