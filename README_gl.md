<!--
NOTA: Este README foi creado automáticamente por <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
NON debe editarse manualmente.
-->

# Dokos para YunoHost

[![Nivel de integración](https://dash.yunohost.org/integration/dokos.svg)](https://ci-apps.yunohost.org/ci/apps/dokos/) ![Estado de funcionamento](https://ci-apps.yunohost.org/ci/badges/dokos.status.svg) ![Estado de mantemento](https://ci-apps.yunohost.org/ci/badges/dokos.maintain.svg)

[![Instalar Dokos con YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=dokos)

*[Le este README en outros idiomas.](./ALL_README.md)*

> *Este paquete permíteche instalar Dokos de xeito rápido e doado nun servidor YunoHost.*  
> *Se non usas YunoHost, le a [documentación](https://yunohost.org/install) para saber como instalalo.*

## Vista xeral

Open-source business management software based on ERPNext, and powered by the highly customizable low-code framework Dodock/Frappe.

Many features are available, such as accounting, billing, CRM, e-commerce, manufacturing, project management, Third-Places management, and so much more.

**Session cookies conflict**
This Dokos package should not be installed on a Yunohost subdomain: 
Yunohost on `yunohost.domain.tld` and Dokos on `dokos.domain.tld` works fine!
Yunohost on `yunohost.domain.tld` and Dokos on `dokos.yunohost.domain.tld` will create conflicts between Yunohost and Dokos session cookies.



**Versión proporcionada:** 4.33.0~ynh1

## Capturas de pantalla

![Captura de pantalla de Dokos](./doc/screenshots/dashboard.png)

## Documentación e recursos

- Web oficial da app: <https://dokos.io/>
- Documentación oficial para usuarias: <https://doc.dokos.io/dokos>
- Documentación oficial para admin: <https://doc.dokos.io/dodock/>
- Repositorio de orixe do código: <https://gitlab.com/dokos/dokos>
- Tenda YunoHost: <https://apps.yunohost.org/app/dokos>
- Informar dun problema: <https://github.com/YunoHost-Apps/dokos_ynh/issues>

## Info de desenvolvemento

Envía a túa colaboración á [rama `testing`](https://github.com/YunoHost-Apps/dokos_ynh/tree/testing).

Para probar a rama `testing`, procede deste xeito:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/dokos_ynh/tree/testing --debug
ou
sudo yunohost app upgrade dokos -u https://github.com/YunoHost-Apps/dokos_ynh/tree/testing --debug
```

**Máis info sobre o empaquetado da app:** <https://yunohost.org/packaging_apps>
