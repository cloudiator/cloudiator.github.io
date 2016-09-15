---
name: Lance
short: Lifecycle Agent
github: https://github.com/cloudiator/lance
javadoc: https://cloudiator.github.io/lance/javadoc/
layout: dev_component
release: 0.1.0
snapshot: 0.2.0-SNAPSHOT
---

## Introduction

Lance is the lifecycle agent running on each virtual machine managed by the Cloudiator toolset. It is
responsible for executing the lifecycle scripts attached to the individual components, thus enacting
their deployment.

## Maven

The latest release of Lance is available in maven central, while the latest
snapshot can be retrieved from the [OSSRH](https://oss.sonatype.org/content/repositories/snapshots/).

### Release

```xml

<dependency>
    <groupId>io.github.cloudiator.lance</groupId>
    <artifactId>client</artifactId>
    <version>0.1.0</version>
</dependency>

```

### Snapshot

```xml

<dependency>
    <groupId>io.github.cloudiator.lance</groupId>
    <artifactId>client</artifactId>
    <version>0.2.0-SNAPSHOT</version>
</dependency>

```

## Usage

### Client

#### Command Line Options

| Option | Description |
| --- | --- |
| lca.client.config.registry | defines the registry that will be used, optional, ("rmiregistry","etcdregistry"), default "rmiregistry" |
| lca.client.config.registry.etcd.hosts | recommended for etcdregistry : comma-separated list of <ip[:port]> information denoting etcd cluster; defaults to localhost:4001 (which limits applicability). |
{: .table .table-striped .table-responsive}

### Server

#### Command Line Options

| Option | Description |
| --- | --- |
| host.ip.public | mandatory: public IP of this VM |
| host.ip.private | mandatory: private (cloud-local IP of that VM) |
| host.vm.cloud.tenant.id | mandatory: ID of tenant; unique in the scope of cloud provider. |
| host.vm.cloud.id | mandatory: ID of cloud provider |
| host.vm.id | mandatory: identifier of VM; unique in the scope of (cloud.id, tenant.id) |
{: .table .table-striped .table-responsive}
