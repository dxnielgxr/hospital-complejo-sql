# hospital-complejo-sql

Base de datos relacional de un hospital en **MySQL 8.0**, con datos de prueba y consultas de práctica sobre `SELECT`, alias, funciones de fecha, agrupaciones, `HAVING` y subconsultas.

## Contenido

```
hospital-complejo-sql/
├── hospital-complejo.sql   # Esquema, datos de prueba y consultas
└── README.md
```

## Requisitos

- MySQL Server 8.0
- MySQL Workbench (o cualquier cliente MySQL)

## Cómo ejecutarlo

1. Abre MySQL Workbench y entra a tu conexión (por ejemplo, `Local instance MySQL80`).
2. Ve a **File > Open SQL Script** y selecciona `hospital-complejo.sql`.
3. Ejecuta todo el script con el botón del rayo ⚡.

> El script empieza con `DROP DATABASE IF EXISTS hospital;`, así que borra y recrea la base de datos `hospital` cada vez que se ejecuta.

Desde la terminal también puedes usar:

```bash
mysql -u root -p < hospital-complejo.sql
```

## Modelo de datos

| Tabla | Descripción |
|-------|-------------|
| `pacientes` | Datos personales de los pacientes |
| `doctores` | Doctores y su especialidad |
| `citas` | Citas médicas (paciente + doctor) |
| `medicamentos` | Catálogo de medicamentos |
| `recetas` | Medicamentos recetados en cada cita |
| `habitaciones` | Habitaciones del hospital (General, UCI, Pediatría) |
| `internaciones` | Relación paciente - habitación con fechas y diagnóstico |
| `facturacion` | Facturas asociadas a pacientes y citas |

### Relaciones principales

- `citas` → `pacientes`, `doctores`
- `recetas` → `citas`, `medicamentos`
- `internaciones` → `pacientes`, `habitaciones`
- `facturacion` → `pacientes`, `citas`

## Consultas incluidas

| # | Descripción | Conceptos |
|---|-------------|-----------|
| 6 | Estado y número de cada habitación con alias | `AS` |
| 7 | Días de hospitalización de cada internación | `DATEDIFF` |
| 8 | Total de citas por doctor | `GROUP BY`, `HAVING` |
| 9 | Pacientes que nunca han sido internados | `NOT IN`, subconsulta |
| 10 | Cantidad de citas por paciente (0 si no tiene), de mayor a menor, sin `JOIN` | subconsulta correlacionada, `IFNULL`, `ORDER BY` |

## Datos de prueba

- 6 pacientes
- 4 doctores
- 4 citas
- 4 medicamentos y 4 recetas
- 4 habitaciones
- 2 internaciones
- 3 facturas
