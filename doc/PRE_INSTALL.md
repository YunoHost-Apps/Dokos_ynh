**Session cookies conflict**
This Dokos package should not be installed on a Yunohost subdomain: 
Yunohost on `yunohost.domain.tld` and Dokos on `dokos.domain.tld` works fine!
Yunohost on `yunohost.domain.tld` and Dokos on `dokos.yunohost.domain.tld` will create conflicts between Yunohost and Dokos session cookies.