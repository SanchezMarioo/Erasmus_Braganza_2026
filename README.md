# Erasmus_Braganza_2026
# 📚 Estructura de Base de Datos - BIP

## 🏫 1. Institución

Representa tanto el instituto como las entidades externas.

**Tabla: `Institucion`**
- `id` (PK)
- `nombre`
- `tipo` (opcional: local / externa)

---

## 👨‍🎓 2. Alumno

**Tabla: `Alumno`**
- `id` (PK)
- `nombre`
- `email` (único)
- `password`
- `area_estudios`
- `institucion_id` (FK → Institucion)

**Relaciones:**
- Un alumno pertenece a una institución
- Una institución tiene muchos alumnos

---

## 👨‍🏫 3. Profesor

**Tabla: `Profesor`**
- `id` (PK)
- `nombre`
- `email` (único)
- `password`
- `departamento`

---

## 👤 4. Usuario y Roles (Administrador incluido)

Sistema flexible para gestionar roles.

**Tabla: `Usuario`**
- `id` (PK)
- `nombre` (nullable)
- `email` (único)
- `password`

**Tabla: `Rol`**
- `id` (PK)
- `nombre` (ALUMNO, PROFESOR, ADMIN)

**Tabla: `UsuarioRol`**
- `usuario_id` (FK → Usuario)
- `rol_id` (FK → Rol)

**Notas:**
- Un profesor puede ser administrador
- Puede haber administradores externos

---

## 🌍 5. BIP (Programa)

**Tabla: `BIP`**
- `id` (PK)
- `nombre`
- `semestre` (1 o 2)
- `modalidad` (remoto / presencial / mixto)
- `institucion_local_id` (FK → Institucion)
- `institucion_colaboradora_id` (FK → Institucion)

---

## 📅 6. Contenido del BIP

**Tabla: `ContenidoBIP`**
- `id` (PK)
- `bip_id` (FK → BIP)
- `fecha_inicio`
- `horario`
- `profesor_id` (FK → Profesor)

**Relaciones:**
- Un BIP tiene un contenido
- Un profesor puede impartir varios BIP

---

## 📝 7. Solicitudes

Gestiona el acceso de alumnos a los BIP.

**Tabla: `Solicitud`**
- `id` (PK)
- `alumno_id` (FK → Alumno)
- `bip_id` (FK → BIP)
- `estado` (pendiente / aceptado / rechazado)
- `fecha_solicitud`

**Notas:**
- El alumno debe solicitar acceso
- El profesor acepta o rechaza

---

## 🎓 8. Inscripciones

Alumnos aceptados en un BIP.

**Tabla: `Inscripcion`**
- `id` (PK)
- `alumno_id` (FK → Alumno)
- `bip_id` (FK → BIP)

---

## 🔗 Relaciones clave

- Institucion → Alumno (1:N)
- Institucion → BIP (doble relación: local y colaboradora)
- Profesor → ContenidoBIP (1:N)
- BIP → ContenidoBIP (1:1)
- Alumno → Solicitud (1:N)
- BIP → Solicitud (1:N)
- Alumno ↔ BIP (N:M mediante Inscripcion)


