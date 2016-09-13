---
layout: docs
title: Application
endpoint: /api/application
---

## Description

The application entity represents a single application within the system.

## GET /api/application

### Request Parameters
 
None

### Response
 
A list of all application entities stored in the database.

### Response Example

```json
[  
   {  
      "links":[  
         {  
            "href":"http://example.com:9000/api/application/1",
            "rel":"self"
         }
      ],
      "name":"Hyperflow"
   },
   {  
      "links":[  
         {  
            "href":"http://example.com:9000/api/application/2",
            "rel":"self"
         }
      ],
      "name":"Scalarm"
   }
]
```

### Response Codes

**Normal Response Code** 200

**Error Response Code** 500 (server error), 403 (forbidden), 401 (unauthorized)

## GET /api/application/{application_id}

### Request Parameters

Parameter      | Description
-------------  | -------------
application_id | The id of the application.
{: .table .table-striped .table-responsive}

### Request
 
This operation does not require a request body.

### Response

Shows the selected application entity.

### Response Example

```json
{
   "links":[
      {
         "href":"http://example.com:9000/api/application/1",
         "rel":"self"
      }
   ],
   "name":"Hyperflow"
}
```

### Response Codes

**Normal Response Code** 200

**Error Response Code** 500 (server error), 403 (forbidden), 401 (unauthorized), 404 (not found)

## PUT /api/application

### Request Parameters

none

### Request
 
The application attribute name.

### Request Example

```json
    {
        "name": "Scalarm"
    }
```

### Response

The created entity. See GET /api/application/{application_id}

### Rsponse Codes

**Normal Response Code** 200

**Error Response Code** 500 (server error), 403 (forbidden), 401 (unauthorized), 400 (bad request)

## POST /api/application/{application_id}

### Request Parameters

Parameter      | Description
-------------  | -------------
application_id | The id of the application to update.
{: .table .table-striped .table-responsive}

### Request Example

```json
    {
        "name": "Scalarm"
    }
```

### Response

The created entity. See GET /api/application/{application_id}

### Response Codes

**Normal Response Code** 200

**Error Response Code** 500 (server error), 403 (forbidden), 401 (unauthorized), 404 (not found), 400 (bad request)

## DELETE /api/application/{application_id}

### Request Parameters 

Parameter      | Description
-------------  | -------------
application_id | The id of the application to delete.
{: .table .table-striped .table-responsive}

### Response

No data.

### Response Codes

**Normal Response Code** 200

**Error Response Code** 500 (server error), 403 (forbidden), 401 (unauthorized), 404 (not found)
