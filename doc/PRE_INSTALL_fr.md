**Conflit de cookies de session**
Ce paquet Dokos ne doit pas être installé sur un sous-domaine de Yunohost : 
Yunohost sur `yunohost.domain.tld` et Dokos sur `dokos.domain.tld` fonctionne très bien!
Yunohost sur `yunohost.domain.tld` et Dokos sur `dokos.yunohost.domain.tld` créera des conflits entre les cookies de session de Yunohost et Dokos.