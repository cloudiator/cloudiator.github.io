---
layout: docs
title: Configuration
---

## Colosseum Configuration

Cloudiator features a central point of configuration: the configuration file of [Colosseum](/components/colosseum.html).
It contains all default configuration options, that can be overwritten by supplying an addition configuration file using the
-Dconfig.file parameter when starting Colosseum. While directly changing the file is also possible it is not recommended.
when changing the configuration file, you need to restart Colosseum for the changes to take effect. 

This new configuration file should at least contain the following information:

{% highlight conf linenos %}

include "application.conf"

# Secret key
# ~~~~~
# The secret key is used to secure cryptographics functions.
# If you deploy your application to several instances be sure to use the same key!
play.crypto.secret = "A_VERY_SECRET_KEY"

# Database configuration
# ~~~~~
db.default.driver = org.mariadb.jdbc.Driver
db.default.url = "mysql://dbuser:dbpassword@dbhost/dbname"

colosseum.nodegroup = "cloudiator-nodegroup"

{% endhighlight %}

| Configuration Option | Description |
| -------------------- | ----------- |
| play.crypto.secret  | [Application Secret](https://www.playframework.com/documentation/2.5.x/ApplicationSecret) |
| db.default.driver | The jdbc driver for the database. By default only the MariaDB driver is present. Can be used for MariaDB and MySQL. |
| db.default.url | [The jdbc connection string](https://dev.mysql.com/doc/connector-j/5.1/en/connector-j-reference-configuration-properties.html) |
| colosseum.nodegroup | A unique identifier for this installation of Cloudiator. Should not be to long. Should only contain - and alphanumeric characters. |
{: .table .table-striped .table-responsive}

The [installation routine](/docs/installation.html) automatically generates a configuration file, generating an application secret and configuring the database
and the colosseum.nodegroup.

## Other configuration options

All other configuration options can be changed by simply overwriting an existing value in the configuration file. All
default configuration values, can be found in the [Colosseum](/components/colosseum.html) configuration file.

## Configuring Sword

While our cloud abstraction framework tries to be as generic as possible, trying to automatically detect
most configuration options, there may be situations where you need to adapt the configuration to your
cloud. Cloudiator offers two possibilities to configure those properties:

- a global configuration in the colosseum configuration file
- a per cloud configuration per API

All configuration parameters can be seen in the [Sword docs](/components/sword.html).

### Global

### Cloud
