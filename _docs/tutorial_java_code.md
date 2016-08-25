---
layout: docs
title: Java Example
---

## Introduction

To make it easy to test cloudiator we have created a java code sample that will
automatically execute the steps mentioned by this tutorial.

## Installation

Simply download the latest build from [our Jenkins](https://omi-dev.e-technik.uni-ulm.de/jenkins/job/cloudiator-examples/lastSuccessfulBuild/artifact/client-examples/target/colosseum-example-jar-with-dependencies.jar). You will
need to have a Java JRE 8 installed to run it.

## Configuration

You will need to create a configuration file. A template for the configuration file can be downloaded
at [Github](https://raw.githubusercontent.com/cloudiator/examples/master/client-examples/config/example.template.properties)
or copied from below.

{% highlight conf linenos %}
 
# Colosseum Configuration
colosseum.url = http://{ip-of-colosseum}:9000/api
colosseum.user = john.doe@example.com
colosseum.password = admin
colosseum.tenant = admin

# Cloud configuration

# Comma seperated list of all clouds
clouds = myCloud

## all configuration options should be present by using cloudName + PropertyName ##

### myCloud

## The name for the cloud
myCloud.cloud.name = myCloud

## The endpoint of the cloud
myCloud.cloud.endpoint = http://endpoint.com

## The username for this cloud
myCloud.cloud.credential.username = myUser

## The credential for this cloud
myCloud.cloud.credential.password = topSecret

## The name for the api
myCloud.api.name = MyApi

## The driver for this cloud
myCloud.api.internalProviderName = openstack-nova

## ID of the image
myCloud.image.providerId = 9c154d9a-fab9-4507-a3d7-21b72d31de97

## ID of the location
myCloud.location.providerId = RegionOne

## ID of the hardware
myCloud.hardware.providerId = 3

## The login for the image
myCloud.image.loginName =

## A comma seperated list of properties for this cloud
myCloud.properties =

{% endhighlight %}

## Running the example

To run the example simply execute:

{% highlight shell %}
java -Dconfig.file=path-to-your-config-file -jar colosseum-example-jar-with-dependencies.jar 
{% endhighlight %}

The program will automatically exit as soon as the mediawiki installation is running.
