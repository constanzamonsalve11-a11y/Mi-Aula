# Mi Aula — primer prototipo funcional

## Probar
Abre `index.html` en Chrome, Edge o Safari. No requiere instalaciones; la importación de Excel necesita conexión a internet para descargar la biblioteca de lectura. CSV y el registro manual funcionan sin ella. También puedes publicar este archivo en GitHub Pages para compartir la interfaz de prueba, **pero no ingreses información real de estudiantes en una instancia de demostración**.

## Funciona hoy
- Crear y seleccionar múltiples cursos.
- Crear y eliminar estudiantes manualmente; importar listas desde CSV, XLSX, XLS y XLSM con vista previa, mapeo de columna y control de duplicados.
- Importar puntajes desde archivos CSV/Excel a una evaluación existente, haciendo coincidir nombres y validando rangos.
- Crear evaluaciones con asignatura, semestre, puntaje máximo y porcentaje de exigencia.
- Ingresar puntajes y convertir automáticamente a notas 1,0–7,0 usando interpolación lineal, 4,0 en el umbral de exigencia.
- Libro de notas, promedios por asignatura, estadísticas y niveles de logro.
- Resúmenes automáticos basados en reglas (no IA generativa todavía).
- Exportar/importar respaldos JSON.

## Limitaciones importantes
La versión de prueba guarda datos en `localStorage` del navegador: **no hay cuentas, sincronización multiusuario, permisos, cifrado de extremo a extremo ni respaldo en servidor**. No utilizar para registros reales institucionales de menores. Las notas y promedios son orientativos y no automatizan la promoción: la normativa y el reglamento de evaluación del establecimiento requieren revisión.

## Estructura del Excel de referencia
- Inicio -> Panel general
- Calcular notas -> Evaluaciones + Libro de notas (puntajes)
- Todas las notas -> Libro de notas
- Nivel de logro -> Niveles de logro
- Promedios -> Libro de notas / promedios
- Resumen -> Panel general / análisis
- Alumnos -> Estudiantes y cursos

La lectura de libros de Excel permite seleccionar la hoja y las columnas, pero NO importa macros, fórmulas como lógica de la app ni reconoce automáticamente todos los diseños de tabla sin intervención humana. No se importaron nombres reales ni registros de calificaciones desde la planilla entregada.

## Arquitectura siguiente versión (producción)
**Cliente:** Next.js/React + TypeScript. **Datos y cuentas:** Supabase Auth + PostgreSQL, Row Level Security; todo acceso identificado por usuario. **IA:** llamadas desde backend (nunca colocar claves API en el navegador); prioridad a datos agregados y seudonimizados, revisión docente. **Documentos:** exportación CSV y PDF.

Esquema sugerido: `profiles(id auth.users, display_name)`, `courses(id, owner_id, name, year, school)`, `course_members(course_id, user_id, role)`, `students(id, course_id, display_name, external_code)`, `subjects(id, course_id, name, counts_in_average)`, `evaluations(id, course_id, subject_id, semester, title, date, max_score, exigency_percent)`, `scores(id, evaluation_id, student_id, points, override_grade, updated_at)`, `audit_log(id, actor_id, entity, entity_id, action, changed_at)`.

RLS debe comprobar membresía y rol en cada operación; nunca confiar solo en el filtro del cliente. Reglas de permisos: dueño/docente asignado puede modificar sus asignaturas, profesor jefe consulta según autorización, administradores institucionales únicamente dentro del tenant correspondiente. Requerimientos antes de producción: política de privacidad, bases legales y contratos con establecimientos, minimización de datos de niños, backups cifrados, borrado/exportación, registro de cambios, monitoreo y pruebas de seguridad.

## Próximas prioridades
1. Autenticación real por email y recuperación de contraseña.
2. Base de datos compartida y RLS por curso/docente.
3. Importación de `.xlsx` / `.xlsm` (solo valores: sin ejecución de macros) y mapeo asistido de columnas.
4. Configuración por colegio de cálculos, ponderaciones, asignaturas y escala; sin automatizar dictámenes de promoción.
5. IA generativa desde servidor para análisis agregado y borradores con validación humana.

## Versión 1.2 · Importación inteligente de planilla completa

En **Cargar archivos → Importación inteligente** selecciona un `.xlsx`, `.xlsm` o `.xls` con las hojas **Alumnos** y **Todas las notas**, organizadas como la planilla de referencia. El sistema identifica la nómina de la columna B en Alumnos, y en Todas las notas lee los encabezados de evaluaciones, los semestres y asignaturas. Presenta una vista previa de cuántos estudiantes, evaluaciones y notas detectó. Después de la confirmación, crea un nuevo curso o combina la información con uno existente.

Las calificaciones del libro de notas ya están en escala 1,0 a 7,0 y se incorporan como **notas directas**, no se vuelven a convertir desde puntaje. Se evita duplicar estudiantes por nombre normalizado; en cargas repetidas en el mismo curso del mismo archivo, las evaluaciones se identifican por nombre de archivo y columna. Datos vacíos no eliminan notas previas. La vista previa y la importación operan localmente en el navegador. Los archivos `.xlsm` **no ejecutan macros**. El lector SheetJS requiere internet al abrir la demo.

Limitaciones: reconocimiento automático especializado para la estructura examinada; otras planillas deben usar el asistente de mapeo por columnas. No hay IA real ni conexión entre distintos dispositivos. Verificar la vista previa y descargar un respaldo antes de combinar datos. No se recomienda usar datos de estudiantes reales en este prototipo sin autenticación y controles de acceso adecuados.

## Versión 1.3 — Importador universal de formatos heterogéneos

En **Cargar archivos → Importador universal** se pueden abrir Excel `.xlsx`, `.xls`, `.xlsm` y CSV (hasta 12 MB). Se ofrece selección de una hoja o todas las hojas, detección heurística de encabezados/nombres, reconocimiento de tablas por columnas de notas o registros largos con estudiante/asignatura/evaluación/nota, vista previa de hasta 12 registros y selección del curso de destino.

La aplicación no utiliza por ahora un modelo de inteligencia artificial: su identificación es heurística y se ejecuta en el navegador. No garantiza reconocer cualquier archivo ni estructuras transpuestas, encabezados fusionados complejos, escalas distintas de 1,0–7,0 o notas ponderadas. Se deben confirmar manualmente los datos, asignaturas y semestres antes de importar. Los formatos que fallen pueden procesarse con la importación guiada previa.

Al volver a importar el mismo archivo y hoja, se actualizan las evaluaciones previamente importadas mediante su identificador de origen. Renombrar el archivo puede crear evaluaciones duplicadas. Los datos siguen en el navegador y no están sincronizados entre cuentas o dispositivos. Nunca cargar datos identificables de alumnos reales hasta implementar autenticación, aislamiento por establecimiento, control de acceso, respaldo seguro y protección de datos.

Para integrar IA real en el futuro: un backend autentificado recibirá únicamente metadatos mínimos de encabezados y muestras anonimizadas, propondrá un mapeo de columnas y requerirá validación humana antes de guardar. Nunca incrustar claves API de IA en `index.html`.

## Versión 1.4 — Documentos Word, PDF y texto

En «Cargar archivos → Importador universal» también se pueden seleccionar PDF (texto seleccionable), Word `.docx`, archivos de texto `.txt` y tablas `.tsv`. PDF se extrae por páginas (máximo 40), DOCX se procesa por tablas y párrafos y TXT/TSV por separadores de columnas. Continúan admitiéndose Excel y CSV. Se usa el mismo mapeo editable y vista previa para confirmar las notas antes de importarlas. Límite 12 MB, 1500 filas por sección analizada.

**Limitaciones:** PDF escaneado, fotos dentro de Word, y PDF de diseño complejo pueden requerir OCR que NO está incluido. Word `.doc` antiguo tampoco está soportado; hay que convertir a `.docx`. La extracción PDF puede fragmentar nombres y calificaciones: no confiar en la importación sin verificación. PDF.js, Mammoth y SheetJS se cargan desde CDN (requiere internet), pero la extracción se realiza dentro del navegador. Todavía **no hay IA generativa ni cuentas, base de datos, seguridad o sincronización reales**. No usar datos reales identificables de menores en este prototipo.

## Versión 1.5 — Biblioteca pedagógica

Nueva sección **Biblioteca pedagógica** para subir PDF con texto seleccionable, DOCX, XLS/XLSX/XLSM, CSV/TSV y TXT. El sistema extrae texto, propone una categoría (evaluación, guía, rúbrica, lista de cotejo, planificación, material de apoyo u otro), asignatura y códigos OA que aparezcan explícitamente en el texto. Permite corregir todos los campos y guardar fichas por curso, filtrarlas, buscarlas, leer extractos y eliminarlas. Las fichas forman parte del respaldo JSON.

**Alcance:** reconocimiento mediante reglas en el dispositivo; no es IA generativa, no analiza imágenes ni PDF escaneado, y no extrae preguntas u objetivos semánticamente. Los archivos originales no se guardan: únicamente metadatos y un extracto de 6.000 caracteres, que se conserva en localStorage. No usar datos reales de menores hasta disponer de autenticación, permisos y almacenamiento seguro. No ejecutar documentos ni macros. Para soportar cuentas y OCR real habrá que desarrollar un backend con controles de acceso y servicio de OCR/IA autorizado.


## Versión 2.0 — Cuentas y nube opcional (integración Supabase)

**Entregado:** pantalla de registro, inicio de sesión, recuperación por email, cierre de sesión, subida y descarga de un espacio personal, sincronización optativa tras elegir la copia principal y políticas RLS por propietario en `supabase.sql`. La plataforma existente de cursos, notas e importadores sigue funcionando.

**No conectado de fábrica:** debes crear tu propio proyecto Supabase, ejecutar `supabase.sql` y rellenar `config.js` con URL y clave pública (anon/publishable). Se recomienda desplegar en HTTPS, no abrir el HTML con `file://` para autenticación. Ver `CONFIGURACION_SUPABASE.md`.

**Límite importante:** sincronización del espacio completo como un JSON, no colaboración en tiempo real ni merge por evaluación. Ediciones simultáneas desde dos dispositivos requieren resolución manual. No hay aún invitaciones docentes, roles UTP, almacenamiento de originales, pruebas automatizadas de seguridad, auditorías ni IA generativa. Antes de usar datos reales de menores, auditar acceso, retención, respaldos y cumplimiento normativo.
