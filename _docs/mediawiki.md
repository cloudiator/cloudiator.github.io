---
layout: docs
title: MediaWiki
---

For the purpose of the tutorial we will use the popular Wiki Web-Application [MediaWiki](https://www.mediawiki.org/wiki/MediaWiki). We will
deploy Mediawiki as three-tier Architecture, using [HAProxy](http://www.haproxy.org/) as Loadbalancer,
the [Apache Webserver](https://httpd.apache.org/) as application server and [MySQL](https://www.mysql.de/) 
respectively the open-source version [MariaDB](https://mariadb.org/) as database. The architecture is depicted in the following picture.

![alt text][mediawiki_architecture]

[mediawiki_architecture]: /images/docs/mediawiki_architecture.png "Architecture of MediaWiki"
{: height="150px"}
