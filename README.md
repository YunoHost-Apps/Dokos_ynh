<!--
N.B.: This README was automatically generated by <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
It shall NOT be edited by hand.
-->

# Dokos for YunoHost

[![Integration level](https://dash.yunohost.org/integration/dokos.svg)](https://ci-apps.yunohost.org/ci/apps/dokos/) ![Working status](https://ci-apps.yunohost.org/ci/badges/dokos.status.svg) ![Maintenance status](https://ci-apps.yunohost.org/ci/badges/dokos.maintain.svg)

[![Install Dokos with YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=dokos)

*[Read this README in other languages.](./ALL_README.md)*

> *This package allows you to install Dokos quickly and simply on a YunoHost server.*  
> *If you don't have YunoHost, please consult [the guide](https://yunohost.org/install) to learn how to install it.*

## Overview

Open-source business management software based on ERPNext, and powered by the highly customizable low-code framework Dodock/Frappe.

Many features are available, such as accounting, billing, CRM, e-commerce, manufacturing, project management, Third-Places management, and so much more.

**Session cookies conflict**
This Dokos package should not be installed on a Yunohost subdomain: 
Yunohost on `yunohost.domain.tld` and Dokos on `dokos.domain.tld` works fine!
Yunohost on `yunohost.domain.tld` and Dokos on `dokos.yunohost.domain.tld` will create conflicts between Yunohost and Dokos session cookies.



**Shipped version:** 4.33.0~ynh1

## Screenshots

![Screenshot of Dokos](./doc/screenshots/dashboard.png)

## Documentation and resources

- Official app website: <https://dokos.io/>
- Official user documentation: <https://doc.dokos.io/dokos>
- Official admin documentation: <https://doc.dokos.io/dodock/>
- Upstream app code repository: <https://gitlab.com/dokos/dokos>
- YunoHost Store: <https://apps.yunohost.org/app/dokos>
- Report a bug: <https://github.com/YunoHost-Apps/dokos_ynh/issues>

## Developer info

Please send your pull request to the [`testing` branch](https://github.com/YunoHost-Apps/dokos_ynh/tree/testing).

To try the `testing` branch, please proceed like that:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/dokos_ynh/tree/testing --debug
or
sudo yunohost app upgrade dokos -u https://github.com/YunoHost-Apps/dokos_ynh/tree/testing --debug
```

**More info regarding app packaging:** <https://yunohost.org/packaging_apps>
