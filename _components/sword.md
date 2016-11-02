---
name: Sword
short: Multi-Cloud Abstraction Layer
github: https://github.com/cloudiator/sword
javadoc: https://cloudiator.github.io/sword/javadoc/
layout: dev_component
release: 0.1.0
snapshot: 0.2.0-SNAPSHOT
---

## Introduction

Sword is the multi-cloud abstraction layer Cloudiator uses to talk to the different
cloud programming interfaces.

## Maven

The latest release of Sword is available in maven central, while the latest
snapshot can be retrieved from the [OSSRH](https://oss.sonatype.org/content/repositories/snapshots/).

### Release

```xml

<dependency>
    <groupId>io.github.cloudiator.sword</groupId>
    <artifactId>service</artifactId>
    <version>0.1.0</version>
</dependency>

```

### Snapshot

```xml

<dependency>
    <groupId>io.github.cloudiator.sword</groupId>
    <artifactId>service</artifactId>
    <version>0.2.0-SNAPSHOT</version>
</dependency>

```

## Supported Providers

Name | Webpage | DriverName | Example
-----|---------|------------|-----------
Amazon AWS EC2 | <https://aws.amazon.com/> | aws-ec2 | [Example](https://github.com/cloudiator/sword/blob/master/examples/src/main/java/EC2Example.java)
Flexiant FCO | <https://www.flexiant.com/flexiant-cloud-orchestrator/> | flexiant | [Example](https://github.com/cloudiator/sword/blob/master/examples/src/main/java/FlexiantExample.java)
Openstack Nova | <http://docs.openstack.org/developer/nova/> | openstack-nova | [Example](https://github.com/cloudiator/sword/blob/master/examples/src/main/java/NovaExample.java)
Google Compute Engine | <https://cloud.google.com/compute/> | google-compute-engine | @todo
{: class="table table-striped table-responsive"}

## Configuration

### Global Configuration options

Global configuration options are valid for all clouds.

| Name | Description | Class |
| ---- | ----------- | ----- |
| sword.regions | A positive filter for the regions retrieved by Sword. Comma-separated list. | [Constants.SWORD_REGIONS](https://github.com/cloudiator/sword/blob/master/api/src/main/java/de/uniulm/omi/cloudiator/sword/api/properties/Constants.java) |
| sword.request.timeout | Request timeout for all request issued by sword. | [Constants.REQUEST_TIMEOUT](https://github.com/cloudiator/sword/blob/master/api/src/main/java/de/uniulm/omi/cloudiator/sword/api/properties/Constants.java) |
{: .table .table-striped .table-responsive}

### Cloud specific configuration options

Cloud specific configuration options are only valid for one cloud.

#### Openstack Nova (openstack-nova)

| Name | Description | Class |
| ---- | ----------- | ----- |
| sword.openstack.floatingIpPool | Sets the floating ip pool from which Sword will try to acquire a floating ip. Only required if more than one exists. | [OpenstackConstants](https://github.com/cloudiator/sword/blob/master/drivers/src/main/java/de/uniulm/omi/cloudiator/sword/drivers/openstack/OpenstackConstants.java) |
| sword.openstack.defaultAvailabilityZone | Sets the default availability group used for starting the virtual machine. Alternative for specifying it directly in the template | [OpenstackConstants](https://github.com/cloudiator/sword/blob/master/drivers/src/main/java/de/uniulm/omi/cloudiator/sword/drivers/openstack/OpenstackConstants.java) |
| sword.openstack.defaultNetwork | The network to which all virtual machines will be attached. Only required if more than one network exists. | [OpenstackConstants](https://github.com/cloudiator/sword/blob/master/drivers/src/main/java/de/uniulm/omi/cloudiator/sword/drivers/openstack/OpenstackConstants.java) |
{: .table .table-striped .table-responsive}

#### Amazon EC2 (aws-ec2)

| Name | Description | Class |
| ---- | ----------- | ----- |
| sword.ec2.ami.query | Filter for EC2 Images. See [Describe Images](http://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeImages.html). | [Ec2Constants](https://github.com/cloudiator/sword/blob/master/drivers/src/main/java/de/uniulm/omi/cloudiator/sword/drivers/ec2/EC2Constants.java) |
| sword.ec2.ami.cc.query | Filter for EC2 Cluster Images. See [Describe Images](http://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeImages.html). | [Ec2Constants](https://github.com/cloudiator/sword/blob/master/drivers/src/main/java/de/uniulm/omi/cloudiator/sword/drivers/ec2/EC2Constants.java) |
| sword.ec2.default.vpc | Sets the id of a [virtual private cloud](https://aws.amazon.com/vpc/). | [Ec2Constants](https://github.com/cloudiator/sword/blob/master/drivers/src/main/java/de/uniulm/omi/cloudiator/sword/drivers/ec2/EC2Constants.java) |
{: .table .table-striped .table-responsive}
