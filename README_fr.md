<!--
Nota bene : ce README est automatiquement généré par <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
Il NE doit PAS être modifié à la main.
-->

# Dokos pour YunoHost

[![Niveau d’intégration](https://dash.yunohost.org/integration/dokos.svg)](https://ci-apps.yunohost.org/ci/apps/dokos/) ![Statut du fonctionnement](https://ci-apps.yunohost.org/ci/badges/dokos.status.svg) ![Statut de maintenance](https://ci-apps.yunohost.org/ci/badges/dokos.maintain.svg)

[![Installer Dokos avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=dokos)

*[Lire le README dans d'autres langues.](./ALL_README.md)*

> *Ce package vous permet d’installer Dokos rapidement et simplement sur un serveur YunoHost.*  
> *Si vous n’avez pas YunoHost, consultez [ce guide](https://yunohost.org/install) pour savoir comment l’installer et en profiter.*

## Vue d’ensemble

Logiciel de gestion d'entreprise open-source basé sur ERPNext, et alimenté par le framework low-code hautement personnalisable Dodock/Frappe.

De nombreuses fonctionnalités sont disponibles, telles que la comptabilité, la facturation, la gestion de la relation client, le commerce électronique, la fabrication, la gestion de projet, la gestion des tiers, et bien plus encore.

**Conflit de cookies de session**
Ce paquet Dokos ne doit pas être installé sur un sous-domaine de Yunohost : 
Yunohost sur `yunohost.domain.tld` et Dokos sur `dokos.domain.tld` fonctionne très bien!
Yunohost sur `yunohost.domain.tld` et Dokos sur `dokos.yunohost.domain.tld` créera des conflits entre les cookies de session de Yunohost et Dokos.



**Version incluse :** 4.33.0~ynh1

## Captures d’écran

![Capture d’écran de Dokos](./doc/screenshots/dashboard.png)

## Documentations et ressources

- Site officiel de l’app : <https://dokos.io/>
- Documentation officielle utilisateur : <https://doc.dokos.io/dokos>
- Documentation officielle de l’admin : <https://doc.dokos.io/dodock/>
- Dépôt de code officiel de l’app : <https://gitlab.com/dokos/dokos>
- YunoHost Store : <https://apps.yunohost.org/app/dokos>
- Signaler un bug : <https://github.com/YunoHost-Apps/dokos_ynh/issues>

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche `testing`](https://github.com/YunoHost-Apps/dokos_ynh/tree/testing).

Pour essayer la branche `testing`, procédez comme suit :

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/dokos_ynh/tree/testing --debug
ou
sudo yunohost app upgrade dokos -u https://github.com/YunoHost-Apps/dokos_ynh/tree/testing --debug
```

**Plus d’infos sur le packaging d’applications :** <https://yunohost.org/packaging_apps>
