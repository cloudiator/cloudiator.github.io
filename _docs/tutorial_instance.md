---
layout: docs
title: Starting the application
---

## Introduction

After describing the application we start instantiating the application
by starting the required virtual machines and installing the components
by creating instances.

## Starting virtual machines

Starting virtual machines is now easy. Simply select the correct offers with respect to Hardware,
Image and Location and pass them to Colosseum.

## Starting instances

Before starting instance, we have to create a new application instance. An application instance is a
logical group for instances, that belong together.

Afterwards, we can start the instances, by binding the already created application components to their
virtual machines.

## Waiting until the deployment is finished

Finally, we have to wait until the instances report an remote state of OK. Using the user interface
we can see the IP Address where the load balancer is located, and access our wiki installation.

![The ip addresses of our VM's][ip]

![The running media wiki][wiki_running]

## API Interaction

### Starting virtual machines

#### UI

![Starting the load balancer VM][ui_lbVM]

![Starting the MariaDB VM][ui_mariaDBVM]

![Starting the wiki VM][ui_wikiVM]

#### REST

```json
{  
   "name": "mariaDBVM",
   "cloud": 1,
   "image": 19,
   "hardware": 10,
   "location": 2
}

{  
   "name": "wikiVM",
   "cloud": 1,
   "image": 19,
   "hardware": 10,
   "location": 2
}

{  
   "name": "lbVM",
   "cloud": 1,
   "image": 19,
   "hardware": 10,
   "location": 2
}
```

#### colosseum-client

```java

    final VirtualMachine mariaDBVM = client.controller(VirtualMachine.class).create(
        VirtualMachineBuilder.of(mariaDBVirtualMachineTemplate)
            .name("mariaDBVM"))
            .build());

    final VirtualMachine wikiVM = client.controller(VirtualMachine.class).create(
        VirtualMachineBuilder.of(wikiVirtualMachineTemplate)
            .name("wikiVM").build());

    final VirtualMachine lbVM = client.controller(VirtualMachine.class).create(
        VirtualMachineBuilder.of(loadBalancerVirtualMachineTemplate)
            .name("lbVM").build());
            
```

### Creating the application instance

#### UI

![Creating the application instance][ui_applicationInstance]

#### REST

```json

{  
   "application": 1
}

```

#### colosseum-client

```java

    final ApplicationInstance appInstance = client.controller(ApplicationInstance.class)
        .create(new ApplicationInstanceBuilder().application(application.getId()).build());

```

### Creating the application component instances

#### UI

![Creating the load balancer instance][ui_lbInstance]

![Creating the wiki instance][ui_wikiInstance]

![Creating the database instance][ui_dbInstance]

#### REST

```json

{  
   "applicationInstance": 1,
   "applicationComponent": 1,
   "virtualMachine": 34
}

{  
   "applicationInstance": 1,
   "applicationComponent": 2,
   "virtualMachine": 33
}

{  
   "applicationInstance": 1,
   "applicationComponent": 3,
   "virtualMachine": 31
}

```

#### colosseum-client

```java

    final Instance lbInstance = client.controller(Instance.class).create(
        new InstanceBuilder().applicationComponent(loadBalancerApplicationComponent.getId())
            .applicationInstance(appInstance.getId()).virtualMachine(lbVM.getId()).build());
    
    final Instance wikiInstance = client.controller(Instance.class).create(
        new InstanceBuilder().applicationComponent(wikiApplicationComponent.getId())
            .applicationInstance(appInstance.getId()).virtualMachine(wikiVM.getId()).build());
    
    final Instance dbInstance = client.controller(Instance.class).create(
        new InstanceBuilder().applicationComponent(mariaDBApplicationComponent.getId())
            .applicationInstance(appInstance.getId()).virtualMachine(mariaDBVM.getId())
            .build());

```

[ui_lbVM]: ../images/ui/lbVM.png
{: .img-responsive}

[ui_mariaDBVM]: ../images/ui/mariaDBVM.png
{: .img-responsive}

[ui_wikiVM]: ../images/ui/wikiVM.png
{: .img-responsive}

[ui_applicationInstance]: ../images/ui/applicationInstance.png
{: .img-responsive}

[ui_lbInstance]: ../images/ui/lbInstance.png
{: .img-responsive}

[ui_wikiInstance]: ../images/ui/wikiInstance.png
{: .img-responsive}

[ui_dbInstance]: ../images/ui/dbInstance.png
{: .img-responsive}

[wiki_running]: ../images/docs/wiki_running.png
{: .img-responsive}

[ip]: ../images/docs/ip.png
{: .img-responsive}
