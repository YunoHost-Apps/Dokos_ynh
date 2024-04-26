- btw it's been discussed yesterday that nextcloud sets character collation on db level like so: https://github.com/YunoHost-Apps/nextcloud_ynh/blob/9c6d1eea8e0aae331ce616e87ede339d616214bf/scripts/install#L82C1-L83C84

- In install script, for the line
```
ynh_exec_warn_less ynh_install_nodejs --nodejs_version=$nodejs_version
```
I better set the value of `$nodejs_version` in _common.sh file right?
Does this command install yarn and nvm too?

yes, usually people set the version of nodejs in _common.sh, and it does install npm, but not yarn
you can get yarn with something like this: https://github.com/YunoHost-Apps/mastodon_ynh/blob/bce29b74dd7c802da34c62fd84ed90005ca5f8c0/manifest.toml#L77

- Dokos depends on Frappe that require python3.10 so it'll have to wait for Yunohost 12.0

- To manage supervisor, check Pixelfed : https://github.com/YunoHost-Apps/pixelfed_ynh/blob/a5ced524d5026bd15daf5f7647395212ae3c09b8/scripts/_common.sh#L102 and https://github.com/YunoHost-Apps/pixelfed_ynh/blob/a5ced524d5026bd15daf5f7647395212ae3c09b8/scripts/install and https://github.com/YunoHost-Apps/pixelfed_ynh/blob/a5ced524d5026bd15daf5f7647395212ae3c09b8/scripts/backup#L45

- Pixelfed use also Redis but I think bench does it already.
