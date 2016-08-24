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
| preInstall | |
| install | |
| postInstall | |
| start | |
| startDetection | |
| stopDetection | |
| preStart | |
| postStart | |
| preStop | |
| stop | |
| postStop | |
| shutdown | |
{: .table .table-striped .table-responsive}

## Virtual Machine Template

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

| Environment Variable | Description |
| --- | --- |
| foo| bar |
{: .table .table-striped .table-responsive}


## Application Instance, Instance and Virtual Machines



[type_model]: /images/docs/type_model.png
{: .img-responsive .center-block}

[instance_type]: /images/docs/instance_type.png
{: .img-responsive .center-block}

[communication_type]: /images/docs/communication_type.png
{: .img-responsive .center-block}

[wiki_wordpress]: /images/docs/wiki_wordpress.png
{: .img-responsive .center-block}
