<!--
注意：此 README 由 <https://github.com/YunoHost/apps/tree/master/tools/readme_generator> 自动生成
请勿手动编辑。
-->

# YunoHost 上的 Dokos

[![集成程度](https://dash.yunohost.org/integration/dokos.svg)](https://ci-apps.yunohost.org/ci/apps/dokos/) ![工作状态](https://ci-apps.yunohost.org/ci/badges/dokos.status.svg) ![维护状态](https://ci-apps.yunohost.org/ci/badges/dokos.maintain.svg)

[![使用 YunoHost 安装 Dokos](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=dokos)

*[阅读此 README 的其它语言版本。](./ALL_README.md)*

> *通过此软件包，您可以在 YunoHost 服务器上快速、简单地安装 Dokos。*  
> *如果您还没有 YunoHost，请参阅[指南](https://yunohost.org/install)了解如何安装它。*

## 概况

Open-source business management software based on ERPNext, and powered by the highly customizable low-code framework Dodock/Frappe.

Many features are available, such as accounting, billing, CRM, e-commerce, manufacturing, project management, Third-Places management, and so much more.

**Session cookies conflict**
This Dokos package should not be installed on a Yunohost subdomain: 
Yunohost on `yunohost.domain.tld` and Dokos on `dokos.domain.tld` works fine!
Yunohost on `yunohost.domain.tld` and Dokos on `dokos.yunohost.domain.tld` will create conflicts between Yunohost and Dokos session cookies.



**分发版本：** 4.33.0~ynh1

## 截图

![Dokos 的截图](./doc/screenshots/dashboard.png)

## 文档与资源

- 官方应用网站： <https://dokos.io/>
- 官方用户文档： <https://doc.dokos.io/dokos>
- 官方管理文档： <https://doc.dokos.io/dodock/>
- 上游应用代码库： <https://gitlab.com/dokos/dokos>
- YunoHost 商店： <https://apps.yunohost.org/app/dokos>
- 报告 bug： <https://github.com/YunoHost-Apps/dokos_ynh/issues>

## 开发者信息

请向 [`testing` 分支](https://github.com/YunoHost-Apps/dokos_ynh/tree/testing) 发送拉取请求。

如要尝试 `testing` 分支，请这样操作：

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/dokos_ynh/tree/testing --debug
或
sudo yunohost app upgrade dokos -u https://github.com/YunoHost-Apps/dokos_ynh/tree/testing --debug
```

**有关应用打包的更多信息：** <https://yunohost.org/packaging_apps>
