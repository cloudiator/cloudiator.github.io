---
layout: docs
title: Cloud Model
---

## Introduction

Before deploying an application with the Cloudiator framework the first step is the definition of
a cloud target.

For this purpose, three entities have to be created:

1. An _Api_, depicting the programming interface the cloud uses, e.g. Nova in case of Openstack.
2. A _Cloud_, depicting the endpoint where the API of the cloud is reachable.
3. A _CloudCredential_, depicting the user credentials for the given cloud endpoint.

## Openstack Example

In this example we will create the required entities using an Openstack Cloud.

For this purpose, we will need the following information for your Openstack Cloud.

1. The _endpoint_ of the Openstack Cloud.
2. Your _tenant_ name.
3. Your _username_.
4. Your API _password_.

For other cloud providers, you can have a look at the [examples section]({{site.url}}/components/sword.html) of Sword. The code examples
list the information required for those providers.

You can easily retrieve this information from the Openstack dashboard:

1. Login 
2. Select the correct _tenant_ from the tenant dropdown menu near the Openstack
logo in the top-left edge. (If it does not exist, you only have one tenant and you can skip this step)
3. Go to the "Compute" tab on the left navigation bar.
4. Click Access & Security.
5. Click the button "Download Openstack RC File".
6. Open the file in the editor: _endpoint_ maps to OS_AUTH_URL, _tenant_ maps to OS_TENANT_NAME, _username_ maps to
OS_USERNAME and _password_ is most likely the password you also used for dashboard authentication or OS_PASSWORD.

## API Interaction

Finally, you can start creating the entities in Cloudiator. Throughout the example, we will list three possibilities: Using the [colosseum-client]({{site.url}}/components/colosseum-client.html)
, direct REST (e.g. by using a client like [Insomnia](https://chrome.google.com/webstore/detail/insomnia-rest-client/gmodihnfibbjdecbanmpmbmeffnmloel)) or
the [user interface]({{site.url}}/components/ui.html).

Before starting you may want to read the basic guide about API authentication and the guides about the respective components.

### Create API

#### colosseum-client

```java
    String apiName = "openstack-nova";
    String internalProviderName = "openstack-nova";

    client.controller(Api.class).updateOrCreate(
        new ApiBuilder().name(apiName)
            .internalProviderName(internalProviderName).build());
```            

#### REST

```json
{
    "internalProviderName": "openstack-nova",
    "name": "openstack-nova"
}
```

#### UI

![Creating a Cloud using the web interface][ui_cloud]

### Create Cloud

#### colosseum-client

```java

Long apiId = 1;
String endpoint = "https://my-cloud-endpoint.com/example";
String cloudName = "My Openstack";

client.controller(Cloud.class).updateOrCreate(
    new CloudBuilder().api(apiId).endpoint(endpoint)
        .name(cloudName).build());
        __
```

#### REST

```json
{
    "name": "My Openstack", 
    "endpoint": "https://my-cloud-endpoint.com/example", 
    "api": 1 
}
```

#### UI

![Creating an API using the web interface][ui_api]

### Create CloudCredential

#### colosseum-client

```java

Long cloudId = 1;
String username = "MyCloudUsername";
String secret = "MySecretCloudPassword";

client.controller(CloudCredential.class).updateOrCreate(
    new CloudCredentialBuilder()
        .cloud(cloudId)
        .secret(secret)
        .user(username)
        .tenant(1)
        .build());
        
```

#### REST

```json
{
    "user": "MyCloudUsername",
    "secret": "MySecretCloudPassword",
    "cloud": 1,
    "tenant": 1
}
```

#### UI

![Creating a Credential using the web interface][ui_credential]

## Discovery

After having created the above entities, the discovery of colosseum will start, 
importing the various offers (_Images_, _Hardware_ and _Locations_) of
the cloud provider. You can see the discovered entities, when accessing the
corresponding API endpoints.
  
 
[ui_api]: ../images/ui/api.png
{: .img-responsive}

[ui_cloud]: ../images/ui/cloud.png
{: .img-responsive}

[ui_credential]: ../images/ui/credential.png
{: .img-responsive}



