---
layout: docs
title: Installation
---

## Installation

Currently, we only provide shell scripts for installing Cloudiator on an
Ubuntu (14.04 LTS) operating system.

You can find the scripts at [Github](https://github.com/cloudiator/installation/tree/master/shell/ubuntu).

Note: it is expected that you execute those scripts on an extra server or virtual machine solely for cloudiator,
as the scripts currently do not check for already existing directories or other installed packages!

Please note that even after the installation has finished, it will take some time until colosseum starts. You
can track the progress by connecting to the screen it is started in (sudo screen -r).
 
## Networking

Cloudiator's home domain requires multiple ports to be opened on the server / virtual machine
it is installed.

| Port | Protocol | Component | Purpose | Notes |
| ---- | -------- | --------- |------- | ----- |
|80|TCP|UI|Cloudiator Webinterface| - |
|4001|TCP|[Lance](/components/lance.html)|etcd registry| only required if etcdregistry is used (default with above scripts)|
|8080|TCP|[Axe](/components/axe.html)|Time-series database| optional, only required if user wants to manually connect to the database|
|9000|TCP|[Colosseum](/components/colosseum.html)|Cloudiator REST API| - |
|33034|TCP|[Lance](/components/lance.html)|rmi registry| only required if rmiregistry is used (etcdregistry is default|
{: .table .table-striped .table-responsive}

The ports required in the remote domain (the virtual machines managed by Cloudiator) will be automatically
opened.




