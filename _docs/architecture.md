---
layout: docs
title: Architecture
---

Cloudiator‘s architecture is split into the home and the remote domain:
the home domain represents an installation of the Cloudiator toolset on the user‘s machine, 
while the remote domain runs in every virtual machine managed by Cloudiator. 

### Home Domain

![Architecture of the Home Domain][architecture_home]

Using Colosseum‘s API the user can submit a new deployment request depicting an description of the application 
and the desired virtual machine configuration. Afterwards, the resource broker will select the 
correct cloud provider offer, that earlier have been discovered by the discovery engine. 
Finally the deployment engine will acquire the virtual machine, install the tools of the remote domain 
and forward the component installation request to Lance.

In addition, the home domain hosts the scaling engine of Axe, responsible of orchestrating its components in the remote domain.

### Remote Domain

![Architecture of the Remote Domain][architecture_remote]

The tools of the remote domain are installed on each virtual machine managed by Cloudiator. 
It contains Lance, our lifecycle agent, responsible for deploying and managing the application components. 
It thereby invokes the interface actions defined by the user during the deployment request. 
It additionally features our monitoring agent Visor, responsible for measuring the application’s runtime behaviour. 
Finally, it contains a time series database used as temporary cache for aggregation, and the cloud scope aggregators 
calculating composite metrics and a distributed manner.  



[architecture_home]: /images/docs/architecture_home.png
{: .img-responsive .center-block}

[architecture_remote]: /images/docs/architecture_remote.png
{: .img-responsive .center-block}
