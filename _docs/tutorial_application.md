---
layout: docs
title: Application Model
---

## Introduction

After the description of the cloud, we can start to model the application.
For this step the following information is needed.

1. For each component, i.e. a _LifecycleComponent_, of the application you need:
    1. a script used for _install_~ing and _start_~ing the component on the virtual machine.
    2. the _Image_ used for booting the virtual machine.
    3. the _Hardware_ used for booting the virtual machine.
    4. the _Location_ used for booting the virtual machine.
2. The _Communication_ dependencies.
    
A more detailed description for the application model is given in the
corresponding [Documentation Section]({{site.url}}/docs/application.html).
    
## Writing the application scripts

The first part of the scripts can be written independently from Cloudiator. In
general we need three scripts:

- one installing the database (MariaDB)
- one installing the application server (apache2) and the wiki
- one installing the load balancer (HaProxy)

For each script we define two start actions:

- one blocking the start as required by [Lance's]({{site.url}}/components/lance.html) Docker deployment
- one non-blocking start action as required by [Lance's]({{site.url}}/components/lance.html) plain deployment.

In addition we define the following arguments for the scripts:

- the application server installation scripts takes the database IP address as argument.
- the load balancer scripts takes multiple application server IP addresses as argument.

This leads to the following scripts, also available at [Github](https://github.com/dbaur/mediawiki-tutorial/tree/master/scripts/shell). 
These scripts rely on apt-get to install packages, and were only tested on Ubuntu 14.04 LTS.

Each of these scripts provides the following functions when used with the depicted arguments:

|Argument|Description|
| --- | --- |
| install | Installs the application on the server. |
| start | Starts the application (non-blocking). |
| startBlocking | Starts the application (blocking). |
| configure | Configures the application, e.g. by downloading or writing configuration files. |
| stop | Stops the application. |
{: .table .table-striped .table-responsive}

### An utility script for common operations

This script simply provides the logic to run apt-get update and dist-upgrade while trying
its best to avoid any interaction with the user.

```shell
#!/bin/bash

apt_update() {
unset UCF_FORCE_CONFFOLD
export UCF_FORCE_CONFFNEW=YES
ucf --purge /boot/grub/menu.lst
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get update
sudo -E apt-get -o Dpkg::Options::="--force-confold" --force-yes -fuy dist-upgrade
}
```

### A script installing the haproxy server

This scripts installs and configures the haproxy server.

```shell
#!/bin/bash

MY_DIR="$(dirname "$0")"
source "$MY_DIR/util.sh"
TMP_DIR="/tmp"
HA_PROXY_CONFIG_URL="https://raw.githubusercontent.com/dbaur/mediawiki-tutorial/master/config/haproxy.cfg"
RSYSLOG_CONFIG_URL="https://raw.githubusercontent.com/dbaur/mediawiki-tutorial/master/config/haProxyRsyslog.cfg"

IPS=${@:2}

install() {
    apt_update

    #install haproxy
    sudo apt-get -y install haproxy wget

    #enable haproxy
    sudo sed -i "s/ENABLED=0/ENABLED=1/g" /etc/default/haproxy

    #configure rsyslog
    wget ${RSYSLOG_CONFIG_URL} -O ${TMP_DIR}/haProxyRsyslog.tmp
    sudo cp ${TMP_DIR}/haProxyRsyslog.tmp /etc/rsyslog.d/haproxy.conf

    sudo /etc/init.d/rsyslog restart
    IPS="127.0.0.1"
    configure

    sudo /etc/init.d/haproxy stop

}

configure() {

#validate ips
if ! [[ -n "$IPS" ]]; then
    echo "Expected list of ips as parameter but got none."
    exit 1
fi

# remove existing tmp file
rm -rf ${TMP_DIR}/haproxy.tmp
# download config template
wget ${HA_PROXY_CONFIG_URL} -O ${TMP_DIR}/haproxy.tmp

# write servers into template
i=1
SERVERS=""
for var in ${IPS}
do
    SERVERS+="server wiki$i $var:80 check\\n"
    ((i++))
done
sudo sed -i -e "s/\${servers}/${SERVERS}/" ${TMP_DIR}/haproxy.tmp

# mv temp file to real location
sudo mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak
sudo mv ${TMP_DIR}/haproxy.tmp /etc/haproxy/haproxy.cfg

# reload haproxy
sudo /etc/init.d/haproxy reload

}

start() {
    # start haproxy
    sudo /etc/init.d/haproxy start
}

startBlocking() {
    # start haproxy and sleep for infinity
    sudo /etc/init.d/haproxy start && sleep infinity
}

stop() {
    # stop haproxy
    sudo /etc/init.d/haproxy stop
}

### main logic ###
case "$1" in
  install)
        install
        ;;
  start)
        start
        ;;
  startBlocking)
        startBlocking
        ;;
  configure)
        configure
        ;;
  stop)
        stop
        ;;
  *)
        echo $"Usage: $0 {install|start|startBlocking|configure|stop}"
        exit 1
esac
```

### A script installing apache2 and mediawiki.

```shell
#!/bin/bash

MY_DIR="$(dirname "$0")"
source "$MY_DIR/util.sh"

TMP_DIR="/tmp"

# Download URL for mediawiki
MW_DOWNLOAD_URL="https://releases.wikimedia.org/mediawiki/1.26/mediawiki-1.26.2.tar.gz"

# Database
DB="wiki"
DB_USER="wiki"
DB_PASS="password"
DB_HOST=$2

# Wiki
NAME="dbaur"
PASS="admin1345"

install() {
    apt_update
    # Install dependencies (apache2, php5, php5-mysql)
    sudo apt-get --yes install apache2 php5 php5-mysql wget
    # remove existing mediawiki archive
    rm -f ${TMP_DIR}/mediawiki.tar.gz
    # download mediawiki tarball
    wget ${MW_DOWNLOAD_URL} -O ${TMP_DIR}/mediawiki.tar.gz
    # remove existing mediawiki folder
    sudo rm -rf /opt/mediawiki
    sudo mkdir -p /opt/mediawiki
    # extract mediawiki tarball
    sudo tar -xvzf ${TMP_DIR}/mediawiki.tar.gz -C /opt/mediawiki --strip-components=1
    # remove existing mediawiki symbolic link
    sudo rm -rf /var/www/html/wiki
    # create symbolic link
    sudo ln -s /opt/mediawiki /var/www/html/wiki
    # enable mod status
    sudo a2enmod status
    # allow server status from everywhere
    sudo sed -i "s/Require local/#Require local/g" /etc/apache2/mods-enabled/status.conf
    # stop apache
    sudo service apache2 stop
}

configure() {
    if ! [[ -n "$DB_HOST" ]]; then
        echo "you need to supply a db host"
        exit 1
    fi
    sudo service apache2 start
    # run mediawiki installation skript
    sudo php /opt/mediawiki/maintenance/install.php --dbuser ${DB_USER} --dbpass ${DB_PASS} --dbname ${DB} --dbserver ${DB_HOST} --pass ${PASS} $NAME "admin"
    sudo service apache2 stop
}

start() {
    sudo service apache2 start
}

startBlocking() {
    sudo service apache2 start && sleep infinity
}

stop() {
    sudo service apache stop
}

### main logic ###
case "$1" in
  install)
        install
        ;;
  start)
        start
        ;;
  startBlocking)
        startBlocking
        ;;
  configure)
        configure
        ;;
  stop)
        stop
        ;;
  *)
        echo $"Usage: $0 {install|start|startBlocking|configure|stop}"
        exit 1
esac
```

### A script installing MariaDB.

```shell
#!/bin/bash

MY_DIR="$(dirname "$0")"
source "$MY_DIR/util.sh"

ROOT_PW="topsecret"
DB="wiki"
DB_USER="wiki"
DB_PASS="password"

install() {
    apt_update
    #set default root password for automated installation
    sudo debconf-set-selections <<< 'mariadb-server mysql-server/root_password password '${ROOT_PW}
    sudo debconf-set-selections <<< 'mariadb-server mysql-server/root_password_again password '${ROOT_PW}
    sudo apt-get --yes install mariadb-server
    sudo service mysql stop
}

start() {
    sudo service mysql start
}

startBlocking() {
    sudo service mysql start && sleep infinity
}


configure() {
    sudo service mysql start

    #create database
    mysql -u root -p${ROOT_PW} -e "CREATE DATABASE $DB;"

    #create user and grant privileges
    mysql -u root -p${ROOT_PW} -e "GRANT ALL PRIVILEGES ON $DB.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';";
    mysql -u root -p${ROOT_PW} -e "FLUSH PRIVILEGES;"

    #configure bind address
    sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

    sudo service mysql stop
}

stop() {
    sudo service mysql stop
}

### main logic ###
case "$1" in
  install)
        install
        ;;
  start)
        start
        ;;
  startBlocking)
        startBlocking
        ;;
  configure)
        configure
        ;;
  stop)
        stop
        ;;
  *)
        echo $"Usage: $0 {install|start|startBlocking|configure|stop}"
        exit 1
esac
```

## Selecting the desired cloud resources

As next step we have to select the desired cloud offers we want to use for the virtual machines
started for the different application components.

For simplicity reasons, we will use the same combination of _Image_, _Hardware_ and 
_Location_ for all _ApplicationComponent_s.

All cloud resources can be retrieved by using the respective list actions of [Colosseum's API]({{site.url}}/api/colosseum.html).

### Defining the virtual machine template

Once we have selected the desired cloud resources, creating a _VirtualMachineTemplate_ is straightforward. As
all components are going to use the same template, we will create only one using the foreign keys of the respective resources.  

## Defining the _LifecycleComponent_s, the _ApplicationComponent_ and the _Application_

When creating the _Application_ with Cloudiator the user has to define the following entities:

- _LifecycleComponents_:
    - A component for the HaProxy Loadbalancer
    - A component for the Apache Webserver including MediaWiki
    - A component for the MariaDB database server.
- _Application_:
    - One application: MediaWiki
- _ApplicationComponent_s
    - three application components, each linking the created components to the application.
    
## Defining the _Communication_

![Communication within the mediawiki application][mediawiki_communication]

The picture depicts the _Communication_ within the Mediawiki _Application_.

_ProvidedPort_s:
    - MariaDB provides the database on port 3306.
    - Wiki (and Apache) provide the web server on port 80.
    - The HaProxy provides the load-balanced website on port 80.
_RequiredPort_s:
    - HaProxy requires the webserver.
    - The wiki requires the database.
_Communication_:
    - LOADBALANCERREQWIKI: link between the HaProxy and the webserver.
    - WIKIREQMARIADB: link between the web-server and the database.
    
It is important to remember the name of the communication entities, as the
environment variables used in the script rely on them.

## Linking the scripts to Cloudiator

As explained in the communication section of the [application model documentation]({{site.url}}/docs/application.html)
Cloudiator uses environment variables to provide IP addresses of downstream components. To account for this
fact, we have to write a simple bridge script parsing this information and calling the corresponding scripts 
with the correct arguments. These scripts can also be found on [Github](https://github.com/dbaur/mediawiki-tutorial/tree/master/scripts/lance).

The corresponding bridge scripts just forward the main argument (see table above) to the original script, but in addition parses the environment variables if necessary
and sends them as arguments to the above scripts.

### HaProxy Bridge Script

```shell

#!/bin/bash

MY_DIR="$(dirname "$0")"

### main logic ###
case "$1" in
  configure)
        if [ -z ${PUBLIC_LOADBALANCERREQWIKI+123} ] ; then
                MESSAGE="Environment variable PUBLIC_LOADBALANCERREQWIKI required, but not set."
                echo $MESSAGE
                exit 3
        elif [ -z ${PUBLIC_LOADBALANCERREQWIKI} ] ; then
                echo "Environment variable PUBLIC_LOADBALANCERREQWIKI required, but not set to reasonable value."
                exit 3
        else
                arr=$(echo $PUBLIC_LOADBALANCERREQWIKI | tr "," "\n")
                for x in $arr
                ## take the last one (because there are only one)
                do
                        echo "PUBLIC_LOADBALANCERREQWIKI > [$x]"
                        WIKI_HOSTS+=$(echo "$x" | sed -e "s/:.*$//")
                        WIKI_HOSTS+=" "
                done
        fi
        ./${MY_DIR}/../shell/haproxy.sh configure $WIKI_HOSTS
        ;;
  *)
        ./${MY_DIR}/../shell/haproxy.sh $@
esac

```

### Mediawiki Bridge Script

```shell

#!/bin/bash

MY_DIR="$(dirname "$0")"


### main logic ###
case "$1" in
  configure)
        DB_HOST="0.0.0.0"
        if [ -z ${PUBLIC_WIKIREQMARIADB+123} ] ; then
                MESSAGE="Environment variable PUBLIC_WIKIREQMARIADB required, but not set."
                echo $MESSAGE
                exit 3
        elif [ -z ${PUBLIC_WIKIREQMARIADB} ] ; then
                echo "Environment variable PUBLIC_WIKIREQMARIADB required, but not set to reasonable value."
                exit 3
        else
                arr=$(echo $PUBLIC_WIKIREQMARIADB | tr "," "\n")
                for x in $arr
                ## take the last one (because there are only one)
                do
                        echo "PUBLIC_WIKIREQMARIADB > [$x]"
                        DB_HOST=$(echo "$x" | sed -e "s/:.*$//")
                done
        fi
        ./${MY_DIR}/../shell/mediawiki.sh configure $DB_HOST
        ;;
  *)
        ./${MY_DIR}/../shell/mediawiki.sh $@
esac

```

### MariaDB Bridge Script

```shell

MY_DIR="$(dirname "$0")"

#!/bin/bash

MY_DIR="$(dirname "$0")"
./${MY_DIR}/../shell/mariaDB.sh $@

```

## API Interaction

Finally, we can start creating the entities using the API of Cloudiator.

### Creating the _Application_

#### REST

```json
    {
        "name":"MediawikiApplication"
    }
```

#### colosseum-client

```java

    Application application = client.controller(Application.class)
        .updateOrCreate(new ApplicationBuilder().name("MediawikiApplication").build());
            
```

#### UI

![Creating the Application][application]

### Creating the _LifecycleComponent_s

#### REST

```json
    {
        "name": "LoadBalancer",
        "preInstall": "sudo apt-get -y update && sudo apt-get -y install git && git clone https://github.com/dbaur/mediawiki-tutorial.git",
        "install": "./mediawiki-tutorial/scripts/lance/haproxy.sh install",
        "start": "./mediawiki-tutorial/scripts/lance/haproxy.sh startBlocking"
    }
    {
        "name": "MediaWiki",
        "preInstall": "sudo apt-get -y update && sudo apt-get -y install git && git clone https://github.com/dbaur/mediawiki-tutorial.git",
        "install": "./mediawiki-tutorial/scripts/lance/mediawiki.sh install",
        "postInstall": "./mediawiki-tutorial/scripts/lance/mediawiki.sh configure",
        "start": "./mediawiki-tutorial/scripts/lance/mediawiki.sh startBlocking"
    }
    {
        "name": "MariaDB",
        "preInstall": "sudo apt-get -y update && sudo apt-get -y install git && git clone https://github.com/dbaur/mediawiki-tutorial.git",
        "install": "./mediawiki-tutorial/scripts/lance/mariaDB.sh install",
        "postInstall": "./mediawiki-tutorial/scripts/lance/mariaDB.sh configure",
        "start": "./mediawiki-tutorial/scripts/lance/mariaDB.sh startBlocking"
    }
```

#### colosseum-client

```java

    String downloadCommand =
        "sudo apt-get -y update && sudo apt-get -y install git && git clone https://github.com/dbaur/mediawiki-tutorial.git";

    LifecycleComponent loadBalancer = client.controller(LifecycleComponent.class).updateOrCreate(
    new LifecycleComponentBuilder().name("LoadBalancer").preInstall(downloadCommand)
        .install("./mediawiki-tutorial/scripts/lance/haproxy.sh install")
        .start("./mediawiki-tutorial/scripts/lance/haproxy.sh startBlocking")
        .build()); 

    LifecycleComponent wiki = client.controller(LifecycleComponent.class).updateOrCreate(
        new LifecycleComponentBuilder().name("MediaWiki").preInstall(downloadCommand)
            .install("./mediawiki-tutorial/scripts/lance/mediawiki.sh install")
            .postInstall("./mediawiki-tutorial/scripts/lance/mediawiki.sh configure")
            .start("./mediawiki-tutorial/scripts/lance/mediawiki.sh startBlocking").build());

    LifecycleComponent mariaDB = client.controller(LifecycleComponent.class).updateOrCreate(
        new LifecycleComponentBuilder().name("MariaDB").preInstall(downloadCommand)
            .install("./mediawiki-tutorial/scripts/lance/mariaDB.sh install")
            .postInstall("./mediawiki-tutorial/scripts/lance/mariaDB.sh configure")
            .start("./mediawiki-tutorial/scripts/lance/mariaDB.sh startBlocking").build());

```

#### UI

![Creating the loadbalancer component using the UI][component_lb]

![Creating the wiki component using the UI][component_wiki]

![Creating the database component using the UI][component_db]

### Creating the _VirtualMachineTemplate_

#### UI

![Creating the virtual machine template][virtualMachineTemplate]

#### REST

```json

{
  "cloud":1,
  "image":1,
  "location":1,
  "hardware":1
}

```

#### colosseum-client

```java

    VirtualMachineTemplate virtualMachineTemplate =  client.controller(VirtualMachineTemplate.class).create(
        new VirtualMachineTemplateBuilder().cloud(cloud.getId()).location(location.getId())
                .image(image).hardware(hardware.getId()).build());

```

### Creating the _ApplicationComponent_s

#### UI

![Creating the application components][application_component]

#### REST

```json

{  
   "application":1,
   "component":1,
   "virtualMachineTemplate":1
}

{  
   "application":1,
   "component":2,
   "virtualMachineTemplate":1
}

{  
   "application":1,
   "component":3,
   "virtualMachineTemplate":1
}

```

#### colosseum-client

```java

    ApplicationComponent loadBalancerApplicationComponent =
        client.controller(ApplicationComponent.class).create(
            new ApplicationComponentBuilder().application(application.getId())
                .component(loadBalancer.getId())
                .virtualMachineTemplate(virtualMachineTemplate.getId()).build());

    ApplicationComponent wikiApplicationComponent =
        client.controller(ApplicationComponent.class).create(
            new ApplicationComponentBuilder().application(application.getId())
                .component(wiki.getId())
                .virtualMachineTemplate(virtualMachineTemplate.getId()).build());

    ApplicationComponent mariaDBApplicationComponent =
        client.controller(ApplicationComponent.class).create(
            new ApplicationComponentBuilder().application(application.getId())
                .component(mariaDB.getId())
                .virtualMachineTemplate(virtualMachineTemplate.getId()).build());

```

### Creating the _RequiredPort_s, and _ProvidedPort_s

#### UI

See communication.

#### REST

```json

{  
   "name":"MARIADBPROV",
   "applicationComponent":1,
   "port":3306
}


{  
   "name":"WIKIPROV",
   "applicationComponent":2,
   "port":80
}
{  
   "name":"WIKIREQMARIADB",
   "isMandatory":"true",
   "applicationComponent":2
}


{  
   "name":"LBPROV",
   "applicationComponent":3,
   "port":80
}
{  
   "name":"LOADBALANCERREQWIKI",
   "updateAction":"./mediawiki-tutorial/scripts/lance/haproxy.sh configure",
   "isMandatory":"true",
   "applicationComponent":3
}

```

#### colosseum-client

```java

    //database
    final PortProvided mariadbprov = client.controller(PortProvided.class).create(
        new PortProvidedBuilder().name("MARIADBPROV")
            .applicationComponent(mariaDBApplicationComponent.getId()).port(3306).build());
    // wiki
    final PortProvided wikiprov = client.controller(PortProvided.class).create(
        new PortProvidedBuilder().name("WIKIPROV")
            .applicationComponent(wikiApplicationComponent.getId()).port(80).build());
    final PortRequired wikireqmariadb = client.controller(PortRequired.class).create(
        new PortRequiredBuilder().name("WIKIREQMARIADB")
            .applicationComponent(wikiApplicationComponent.getId()).isMandatory(true).build());
    // lb
        final PortProvided lbprov = client.controller(PortProvided.class).create(
            new PortProvidedBuilder().name("LBPROV")
                .applicationComponent(loadBalancerApplicationComponent.getId()).port(80).build());
        final PortRequired loadbalancerreqwiki = client.controller(PortRequired.class).create(
            new PortRequiredBuilder().name("LOADBALANCERREQWIKI")
                .applicationComponent(loadBalancerApplicationComponent.getId())
                .isMandatory(false)
                .updateAction("./mediawiki-tutorial/scripts/lance/haproxy.sh configure")
                .build());
                
```

### Creating the _Communication_

#### UI

![Creating the communication and the ports][communication]

#### REST



#### colosseum-client

```java

    // wiki communicates with database
    final Communication wikiWithDB = client.controller(Communication.class).create(
        new CommunicationBuilder().providedPort(mariadbprov.getId())
            .requiredPort(wikireqmariadb.getId()).build());
    //lb communicates with wiki
    final Communication lbWithWiki = client.controller(Communication.class).create(
        new CommunicationBuilder().providedPort(wikiprov.getId())
            .requiredPort(loadbalancerreqwiki.getId()).build());

```


[mediawiki_communication]: ../images/docs/mediawiki_communication.png
{: .img-responsive .center-block}

[component_db]: ../images/ui/component_db.png
{: .img-responsive}

[component_lb]: ../images/ui/component_lb.png
{: .img-responsive}

[component_wiki]: ../images/ui/component_wiki.png
{: .img-responsive}

[application]: ../images/ui/application.png
{: .img-responsive}

[application_component]: ../images/ui/application_components.png
{: .img-responsive}

[virtualMachineTemplate]: ../images/ui/virtualMachineTemplate.png
{: .img-responsive}

[communication]: ../images/ui/communication.png
{: .img-responsive}

