# ALMAS — perfil público curado para Hermes

Distribución de perfil de Hermes con la identidad y el método general de ALMAS. Está preparada para instalarse y actualizarse con `hermes profile`; **no es un espejo del perfil activo ni el motor completo de ALMAS**.

## Qué incluye y qué no

- Incluye únicamente `SOUL.md` y `distribution.yaml` como archivos administrados por la distribución.
- No incluye el núcleo de investigación, corpus, skills privados, herramientas/MCP, configuración de proveedor, credenciales, memoria, sesiones ni historial.
- Cada instalación configura su propio proveedor, credenciales y herramientas en su equipo.

## Instalar

Requiere Hermes Agent 0.14.0 o posterior.

```sh
hermes profile install github.com/2926097/almas-hermes-agent --alias
almas-public setup
almas-public chat
```

El instalador muestra la ficha y pide confirmación. La distribución no necesita ni recibe claves del usuario.

## Actualizar

Cuando se publique una actualización revisada, cada usuario podrá aplicarla con:

```sh
hermes profile update almas-public
```

La distribución administra solo `SOUL.md` y `distribution.yaml`; la configuración local, credenciales, memoria y sesiones del usuario quedan fuera de la copia pública y no deben compartirse.

## Privacidad y publicación

- Este repositorio no admite conversaciones, expedientes ni casos reales de terceros, aunque se sustituyan nombres. La seudonimización no garantiza que una persona no pueda ser reidentificada.
- Si hace falta ilustrar un método, usa ejemplos completamente sintéticos, no derivados de un caso real.
- Los cambios no se sincronizan automáticamente desde el agente en ejecución. La publicación es manual: `publish.sh` muestra el diff de una lista cerrada de archivos y espera confirmación antes de enviar nada.
- Antes de proponer cualquier archivo nuevo, revisa su procedencia, licencia, rutas locales, nombres, contactos, fechas singulares y detalles que puedan identificar a alguien. La revisión humana sigue siendo obligatoria; ningún filtro automático garantiza anonimato.

## Estado de licencia

El repositorio aún no declara una licencia de reutilización. Que sea público permite verlo, pero no concede por sí solo permiso para copiarlo, modificarlo o redistribuirlo. La licencia debe definirse antes de anunciarlo como software abierto.
