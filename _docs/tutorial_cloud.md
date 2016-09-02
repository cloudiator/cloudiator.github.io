---
layout: docs
title: Cloud Model
---

## Introduction

Before deploying an application within the Cloudiator framework is the definition of
a Cloud target.

For this purpose, three entities have to be created:

1. An Api, depicting the programming interface the cloud uses, e.g. Nova in case of Openstack.
2. A Cloud, depicting the endpoint where the API of the cloud is reachable.
3. A CloudCredential, depicting the user credentials for the given cloud endpoint.

## Openstack Example

In this example we will create the required entities, using an Openstack Cloud.

For this purpose, you will need the following information for your Openstack Cloud.

1. The endpoint of the Openstack Cloud.
2. Your tenant name.
3. Your username.
4. Your API Password.

For other cloud providers, you can have a look at the [examples section](/components/sword.html) of Sword. The code examples
list the information required for those Providers.

You can easily retrieve this information from the Openstack Dashboard:

1. Login 
2. Select the correct tenant from the tenant dropdown menu near the Openstack
Logo in the top-left edge. (If this does not exist, you only have one tenant and you can skip this step)
3. Go to the Compute Tab on the left navigation bar.
4. Click Access & Security.
5. Click the button Download Openstack RC File.
6. Open the file in the editor, endpoint maps to OS_AUTH_URL, tenant maps to OS_TENANT_NAME, username maps to
OS_USERNAME and password is most likely the password you also used for dashboard authentication or OS_PASSWORD.

## API Interaction

Finally, you can start creating the entities in Cloudiator. Throughout the example, we will list two possibilities: Using the [colosseum-client](/components/colosseum-client.html)
or direct REST (e.g. by using a client like [Insomnia](https://chrome.google.com/webstore/detail/insomnia-rest-client/gmodihnfibbjdecbanmpmbmeffnmloel)).

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

After having created the above entities, the discovery of colosseum will start
running, importing the various offers (Images, Hardware and Locations) of
the cloud provider. You can see the discovered images, when accessing the
correct API endpoints.
  
 
[ui_api]: ../images/ui/api.png
{: .img-responsive}

[ui_cloud]: ../images/ui/cloud.png
{: .img-responsive}

[ui_credential]: ../images/ui/credential.png
{: .img-responsive}



