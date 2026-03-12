# ObraCheck

Aplicación móvil Android para gestión simple de obras de construcción, diseñada para uso diario en campo.

## 1) Visión del producto

**Objetivo principal:** centralizar en una app móvil extremadamente simple la operación básica de una obra:
- trabajadores
- asistencia
- pagos
- materiales
- avance
- evidencia fotográfica
- presupuesto básico
- reportes automáticos

### Principios de diseño
- Interfaz minimalista y clara.
- Botones grandes (usable con guantes).
- Flujos de 1–3 taps para acciones frecuentes.
- Optimizada para uso en obra y con soporte offline-first.

---

## 2) Roles y permisos

### Administrador (arquitecto/contratista)
Puede:
- crear y editar obras
- registrar trabajadores
- ver dashboard y reportes
- controlar materiales
- registrar avances
- ver y validar pagos
- generar reportes para cliente

### Supervisor (maestro de obra)
Puede:
- registrar asistencia (entrada/salida)
- subir fotos
- registrar avances
- registrar materiales usados

---

## 3) Módulos funcionales (MVP Android)

1. Gestión de obras  
2. Gestión de trabajadores  
3. Checador de asistencia  
4. Cálculo automático de pagos  
5. Control de materiales  
6. Registro de avance de obra  
7. Registro fotográfico  
8. Presupuesto básico  
9. Línea de tiempo de obra  
10. Evidencia automática (GPS + foto + hora)  
11. Reportes automáticos  

---

## 4) Funciones especiales

## 4.1 Evidencia automática de trabajo
Cada registro importante guarda automáticamente:
- hora exacta
- ubicación GPS
- foto opcional

Aplica en:
- entrada/salida de trabajador
- registro de avance
- uso de material
- fotos de progreso

**Objetivo:** reducir conflictos laborales y documentar trabajo real en campo.

## 4.2 Línea de tiempo visual de obra
La app construye una cronología automática con eventos de:
- avances
- fotos
- materiales usados
- asistencia relevante

Ejemplo:
- Día 1: Excavación de cimientos
- Día 10: Colado de zapatas
- Día 25: Levantamiento de muros
- Día 40: Colado de losa

## 4.3 Reporte automático de pagos
Fórmula base:

`pago_total = salario_diario × días_trabajados`

Salida ejemplo:
- Trabajador: Juan Pérez
- Especialidad: Albañil
- Días trabajados: 5
- Salario diario: $450
- Total a pagar: $2,250

Acción principal: **Enviar resumen** (WhatsApp / correo).

---

## 5) Modelo de datos propuesto

## Tabla `usuarios`
- id
- nombre
- correo
- contraseña
- rol
- fecha_creacion

## Tabla `obras`
- id
- nombre_obra
- direccion
- cliente
- fecha_inicio
- fecha_fin_estimada
- estado

## Tabla `trabajadores`
- id
- nombre
- telefono
- especialidad
- salario_diario
- fecha_registro

## Tabla `asistencia`
- id
- trabajador_id
- obra_id
- fecha
- hora_entrada
- hora_salida
- gps_latitud
- gps_longitud
- foto_url
- horas_trabajadas

## Tabla `pagos`
- id
- trabajador_id
- obra_id
- dias_trabajados
- monto_total
- fecha_pago
- estado_pago

## Tabla `materiales`
- id
- obra_id
- nombre_material
- cantidad
- unidad
- costo_unitario
- fecha_registro

## Tabla `uso_material`
- id
- material_id
- obra_id
- cantidad_usada
- gps_latitud
- gps_longitud
- foto_url
- fecha

## Tabla `avances`
- id
- obra_id
- descripcion
- porcentaje_avance
- gps_latitud
- gps_longitud
- foto_url
- fecha

## Tabla `fotos`
- id
- obra_id
- avance_id
- url_foto
- descripcion
- fecha

## Tabla `presupuestos`
- id
- obra_id
- descripcion
- cantidad
- precio_unitario
- subtotal

---

## 6) Pantallas principales

1. **Login**: correo, contraseña, botón iniciar sesión.
2. **Dashboard**: obras activas, trabajadores activos, avance promedio, materiales.
3. **Lista de obras**: crear/editar/entrar.
4. **Detalle de obra**: trabajadores, asistencia, materiales, avance, fotos, presupuesto, timeline.
5. **Registro de trabajadores**: nombre, teléfono, especialidad, salario.
6. **Checador de asistencia**: seleccionar trabajador + botones Entrada/Salida.
7. **Control de materiales**: nombre, cantidad, unidad, costo.
8. **Uso de material**: material, cantidad usada, foto, ubicación.
9. **Registro de avance**: descripción, porcentaje, foto, ubicación.
10. **Subir fotos**: tomar foto + descripción.
11. **Presupuesto básico**: concepto, cantidad, precio unitario, subtotal/total.
12. **Línea de tiempo**: vista cronológica de eventos.

---

## 7) Reglas de negocio

- `horas_trabajadas = hora_salida - hora_entrada`
- `pago_total = salario_diario × dias_trabajados`
- `avance_total = promedio(porcentaje_avance)`

Validaciones mínimas:
- no permitir salida sin entrada
- no permitir porcentaje_avance fuera de 0–100
- geolocalización opcional solo si permisos denegados; en otro caso obligatoria
- foto opcional en asistencia, recomendada en avance/material

---

## 8) Reportes automáticos

Reporte semanal de obra (PDF o resumen compartible) con:
- trabajadores y días trabajados
- pagos calculados
- avance
- materiales registrados/usados
- fotografías destacadas

Canales de salida:
- WhatsApp
- correo electrónico

---

## 9) Arquitectura recomendada

## Opción A (rápida para MVP): Flutter + Firebase
- App Android: Flutter
- Backend: Firebase (Auth, Firestore, Cloud Functions)
- Imágenes: Cloud Storage
- Reportes: Cloud Functions (generación PDF)
- Ventaja: despliegue más rápido

## Opción B (más control): React Native + Node.js + PostgreSQL
- App Android: React Native
- API: Node.js (NestJS o Express)
- DB: PostgreSQL
- Imágenes: Cloud Storage (S3/GCS)
- Ventaja: control total de lógica e integraciones

---

## 10) Estrategia offline (recomendada)

- Cache local de catálogos (trabajadores, materiales, obras).
- Cola local de eventos (asistencia, avances, uso_material, fotos).
- Sincronización por lotes al recuperar conectividad.
- Estados de sync por registro: `pendiente`, `sincronizado`, `error`.

---

## 11) Roadmap sugerido

### Fase 1 (MVP)
- Login y roles
- Obras + trabajadores
- Asistencia con evidencia automática
- Pagos semanales automáticos
- Registro de avance + fotos
- Reporte semanal compartible

### Fase 2
- Materiales y presupuesto básico completo
- Timeline visual avanzada con filtros
- Modo offline robusto

### Fase 3
- Firma digital de conformidad
- Alertas inteligentes (atrasos/sobrecosto)
- Panel web para clientes

---

## 12) KPIs de éxito inicial

- Tiempo promedio de registro de entrada/salida < 10 segundos.
- % de registros con evidencia completa (hora + GPS + foto) > 80%.
- Reducción de conflictos por asistencia/pagos.
- Reporte semanal emitido en < 2 minutos.

