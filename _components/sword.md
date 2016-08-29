---
name: Sword
short: Multi-Cloud Abstraction Layer
github: https://github.com/cloudiator/sword
javadoc: https://cloudiator.github.io/sword/javadoc/
layout: dev_component
---

## Introduction

Sword is the multi-cloud abstraction layer Cloudiator uses to talk to the different
cloud programming interfaces.

## Maven

The latest release of Sword is available in maven central, while the latest
snapshot can be retrieved from the [OSSRH](https://oss.sonatype.org/content/repositories/snapshots/).

### Release

{% highlight xml %}

<dependency>
    <groupId>io.github.cloudiator.sword</groupId>
    <artifactId>service</artifactId>
    <version>0.1.0</version>
</dependency>

{% endhighlight %}

### Snapshot

{% highlight xml %}

<dependency>
    <groupId>io.github.cloudiator.sword</groupId>
    <artifactId>service</artifactId>
    <version>0.2.0-SNAPSHOT</version>
</dependency>

{% endhighlight %}

## Supported Providers

{::options parse_block_html="true" /}
<div class="table-responsive">
Name | Webpage | DriverName | Example
-----|---------|------------|-----------
Amazon AWS EC2 | https://aws.amazon.com/ | aws-ec2 | [Example](https://github.com/cloudiator/sword/blob/master/examples/src/main/java/EC2Example.java)
Flexiant FCO | https://www.flexiant.com/flexiant-cloud-orchestrator/ | flexiant | [Example](https://github.com/cloudiator/sword/blob/master/examples/src/main/java/FlexiantExample.java)
Openstack Nova | http://docs.openstack.org/developer/nova/ | openstack-nova | [Example](https://github.com/cloudiator/sword/blob/master/examples/src/main/java/NovaExample.java)
Google Compute Engine | https://cloud.google.com/compute/ | google-compute-engine | @todo
{: class="table table-striped table-responsive"}
</div>

## Configuration

### Global Configuration options

| Name | Description | Class |
| ---- | ----------- | ----- |
| sword.regions | A positive filter for the regions retrieved by Sword. Comma-separated list. | [Constants](https://github.com/cloudiator/sword/blob/master/api/src/main/java/de/uniulm/omi/cloudiator/sword/api/properties/Constants.java) |
{: .table .table-striped .table-responsive}

### Cloud specific configuration options

#### openstack-nova

| Name | Description | Class |
| ---- | ----------- | ----- |
| sword.openstack.floatingIpPool |||
| sword.openstack.defaultAvailabilityZone |||
| sword.openstack.defaultNetwork |||
{: .table .table-striped .table-responsive}
