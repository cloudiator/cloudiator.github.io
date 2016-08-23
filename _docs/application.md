---
layout: docs
title: Application Description
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
and an Application. This allows reuse from Components between different Applications, e.g. a once create
haProxy Component could be reused in the Application "MediaWiki" but also in a "Wordpress" Application.

![Type model of cloudiator][type_model]


## Communication

![Communication Type Model][communication_type]






[type_model]: /images/docs/type_model.png
{: .img-responsive .center-block}

[instance_type]: /images/docs/instance_type.png
{: .img-responsive .center-block}

[communication_type]: /images/docs/communication_type.png
{: .img-responsive .center-block}
