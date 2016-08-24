---
layout: docs
title: Cloud Model
---

## Introduction

The Cloud Model is split into two parts:

- the cloud model describing the cloud provider, its API and the credentials used for authentication at
the provider's API.
- the resource models describe the offers of the cloud providers.

## Cloud Model (Cloud, Api, CloudCredential)

The cloud model contains the entities Api, Cloud and Cloud Credential. The Api describes the application
programming interface of the cloud provider. A list supported cloud API's can be retrieved on the documentation
of our abstraction layer [Sword](/components/sword.html). The cloud describes the provider itself and
therefore references the API and links it to a specific endpoint. The cloud credential finally providers
the credentials used for authenticating an user at the API endpoint.

![Cloud Model][cloud_model]

The following picture providers an example of possible values. It describes the cloud "My Private Cloud"
that uses the Openstack Nova API and is used by the cloudiator user John Doe by the credentials 
{jdoe, secret}.

![Cloud Model Example][cloud_model_example]

## Resource Model (Hardware, Image, Location)

The resource model describes the resources offered by a cloud provider. The most common resources are:

- Hardware: the hardware used for starting the virtual machine.
- Image: the cloud image used for starting the virtual machine. 
- Location: the (virtual) location used for starting the virtual machine
 
The resource model is split into two different
scopes:

- the cloud provider and user specific scope, where concrete offers of cloud providers are stored using
their cloud specific identifier.
- the cloud provider independent layer, storing abstract meta-data about the offers like number of cores of
a hardware offer or the operating system of an image offer.

![Resource Model][resource_model]

The following picture gives an example:

![Resource Model Example][resource_model_example]

## Discovery



[cloud_model]: /images/docs/cloud_model.png
{: .img-responsive .center-block}

[cloud_model_example]: /images/docs/cloud_model_example.png
{: .img-responsive .center-block}

[resource_model]: /images/docs/resource_model.png
{: .img-responsive .center-block}

[resource_model_example]: /images/docs/resource_model_example.png
{: .img-responsive .center-block}

