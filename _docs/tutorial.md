---
layout: docs
title: Introduction
---

This tutorial provides a detailed step-by-step guide, helping you to deploy your first application
using the Cloudiator toolset.

Before starting with the tutorial, install the latest version of the Cloudiator toolset
as described in the [Installation]({{site.url}}/docs/installation) section of the Documentation section.

This tutorial will cover the following steps:

1. A short introduction on the sample application (Mediawiki).
2. We will describe an Openstack Cloud so that it can be used with Cloudiator.
3. We will describe Mediawiki using bash scripts so it can be deployed with Cloudiator.
4. We will deploy Mediawiki using Cloudiator.
5. We will add a Scaling Rule and use Cloudiator's Adaptation mechanism to scale MediaWiki.

Each step will be two-fold. First it will describe and explain the steps needed in detail by
providing knowledge and background information. At the end, each section will describe the actions
required to execute the steps with the Cloudiator toolset, using a) the [REST-API]({{site.url}}/api/colosseum.html), 
b) our [java client]({{site.url}}/components/colosseum-client.html) and c) our [user interface]({{site.url}}/components/ui.html).
