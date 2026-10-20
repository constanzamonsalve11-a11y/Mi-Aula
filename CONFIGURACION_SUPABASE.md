# Mi Aula 2.0 — Activar cuentas de docentes

1. Crea un proyecto propio en https://supabase.com/dashboard. Usa un proyecto de pruebas sin datos reales de estudiantes.
2. Abre **SQL Editor**, copia todo el contenido de `supabase.sql` y ejecútalo. Habilita Row Level Security para la tabla; el script lo hace.
3. En **Project Settings → API / Data API**, copia **Project URL** y **publishable key** (o la anon key pública). Pega únicamente esos valores en `config.js`. **Nunca** copies claves service_role ni secretos privados al repositorio.
4. En **Authentication → Providers → Email**, habilita el registro con correo y confirma la configuración de verificación. En **Authentication → URL Configuration**, añade la dirección HTTPS de tu web a Site URL y Redirect URLs para restaurar contraseñas.
5. Sube todos los archivos de `mi-aula-mvp` a GitHub Pages o un sitio web HTTPS. Abre **Mi cuenta y nube** y crea una cuenta de prueba. Confirma el correo si se solicita.
6. Inicia sesión. Descarga primero un respaldo JSON de tus datos locales. Usa **Subir a la nube** para conservar los datos locales o **Descargar desde la nube** para traer los que ya guardaste en otro dispositivo. Después se activa la sincronización automática.
7. Prueba con **dos cuentas diferentes**: cada una debe ver exclusivamente su propia copia en Supabase (RLS). Prueba cierre de sesión y verificación de correo.

## Precauciones y límites
- Modo nube: **una copia completa por docente**, sin colaboración ni mezcla por registro. No edites desde dos dispositivos a la vez.
- Las fichas de la biblioteca contienen extractos textuales, pero **no** copias de los originales.
- La IA generativa y OCR todavía no están implementados.
- Para lanzamiento público hace falta modelo relacional por curso, roles institucionales, copias de seguridad verificadas, auditoría, prevención de abuso, límites de archivo y cumplimiento legal.
- Usa datos **ficticios** en esta fase. La RLS da aislamiento básico por cuenta, pero no sustituye una auditoría de seguridad ni un análisis jurídico.
- El correo de recuperación utiliza la configuración de Supabase y puede exigir flujo adicional para permitir cambiar efectivamente la contraseña; por ahora solo envía el enlace.
