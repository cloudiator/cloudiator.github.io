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

### Server
