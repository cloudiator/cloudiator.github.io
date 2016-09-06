---
layout: docs
title: Application Model
---

## Introduction

When deploying applications with Cloudiator the user first of all needs to describe the application.
This application description is generelly split into a type and instance model:

- Types
    - Application: groups multiple components to form an application
    - Application Component: glue between component and application
    - (Lifecycle) Component: provides interfaces action (e.g. bash-scripts) for managing the component
        lifecycle
    - Communication/Port: describes communication dependencies between components of an application
- Instances
    - Virtual Machine
    - Instance: binds a component to a VM
    
![Type model vs instance model][instance_type]

## Application, ApplicationComponents and (Lifecycle)Component

As described above, the application description is threefold and consists of Components, ApplicationComponents
and an Application.

![Type model of cloudiator][type_model]

This allows the reuse of components across other applications. A user could needs to model the MariaDB component
only once and afterwards can reuse it in other applications, e.g. a wiki application and a WordPress application.

![Reuse of application components][wiki_wordpress]

| Lifecycle Action | Description |
| --- | --- |
| preInstall | Executed before running the installation of the component. Can be used for e.g. downloading the required scripts. |
| install | Installation action. Should be used for installing the component. |
| postInstall | Executed after the installation of the component. First lifecycle action where the  |
| preStart | Preparation for the start. |
| start | (Mandatory) Start the application. Needs to be blocking for Docker usage and unblocking for Plain usage. |
| startDetection | Detection of the start. Will be used to check if the application started successfully. |
| stopDetection | Detects a stop of the application. Used to detect failure of the application. |
| postStart | Executed after the installation was successfully started. |
| preStop | Executed shortly before the service is stopped. |
| stop | Stops the application. |
| postStop | Executed after the application was stopped. |
| shutdown | Force-stops the application. |
{: .table .table-striped .table-responsive}

## Virtual Machine Template

The virtual machine template entity provides the glue between the cloud/resource model and the application model.
It describes the concrete offers that will be used to power a virtual machine for the application component. A virtual
machine template always represents the tuple of Image, Hardware and Location.

## Communication

Communication describes the dependencies between components of an application. Every component of
an application can define communication offers via provided ports that can be consumed by other components
of the application via required ports. This link between components is established by communication
entities, linking the described ports. Communication to the outside world (e.g. the user) is depicted
by using an provided port but not attaching any communication entity to it.

Communication is described on type and application component level. This means, 
that for every application where a component is reused, a different communication pattern can be
configured.

The communication description also acts as dependency mechanism, that is used by Cloudiator to derive
the provisioning order of the component instances. Cloudiator offers two types of dependency mechanism:

- a mandatory communication, where the component on the providing side needs to be started before the component
    consuming the communication (required side). This is the default mechanism and it is depicted by setting the mandatory
    flag in the communication entity to true.
- a non-mandatory communication, where both component can start independently from each other. The user may supply
    a script that is later called on the consuming side of the application as soon as the providing side is started. This
    can be modelled by setting the mandatory flag to false and by providing an update action in the required port entity.
    
Tip: If possible, use the non-mandatory communication. While it is in general more difficult to describe with respect
to scripting, it allows Cloudiator to achieve more parallelism when deploying the application resulting in faster
deploy times.

![Communication Type Model][communication_type]

When deploying the application, the owner's scripts can access the defined communications. Cloudiator will set
environment variables based on downstream dependencies and the name of the defined communication. The environment
variables are depicted in the following table.

| Environment Variable | Description |
| --- | --- |
| CONTAINER_IP | the IP address of the container. It should be used for binding purposes |
| CLOUD_IP | the IP address of the virtual machine running the container. This IP is probably cloud provider-specific and cannot be reached from outside the cloud |
| PUBLIC_IP | the public IP address of the virtual machine running the container, if available |
| CONTAINER_{NameOfPort} | the port number as specified in the deployment model and as accessible from within the container. Should be used for binding. |
| CLOUD_{NameOfProvidedPort} | the port number as accessible from within the cloud |
| PUBLIC_{NameOfProvidedPort} | the port number as accessible from the outside world (i.e., by using the public IP) |
| PUBLIC_{NameOfRequiredPort}| provides access to the public IP addresses and public ports of all downstream component instances (comma separated list of ip:port pairs)|
| CLOUD_{NameOfRequiredPort} | provides access to the cloud-internal IP addresses and cloud-internal ports of all downstream component instances. Note that addresses of component instances not hosted in the same cloud as the local component instance are still in the list, but very likely traffic cannot be routed to them. |
| CONTAINER_{NameOfRequiredPort} | provides access to the container-internal IP addresses and container-internal ports of all downstream component instances. Note that addresses of component instances not hosted in the very same container as the local component instance are still in the list, but very likely cannot be routed to |
{: .table .table-striped .table-responsive}


## Application Instance, Instance and Virtual Machines

The instance model is represented by three main entities:
    - an application instance: groups multiple component instances of the same application. This allows multiple running instances of the same application.
    - an instance: represents an installation of an application component on a virtual machine.
    - a virtual machine: a running virtual machine instantiated from the virtual machine template.

[type_model]: /images/docs/type_model.png
{: .img-responsive .center-block}

[instance_type]: /images/docs/instance_type.png
{: .img-responsive .center-block}

[communication_type]: /images/docs/communication_type.png
{: .img-responsive .center-block}

[wiki_wordpress]: /images/docs/wiki_wordpress.png
{: .img-responsive .center-block}
