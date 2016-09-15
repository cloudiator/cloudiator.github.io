---
layout: docs
title: Communication
endpoint: /api/communication
---

## Description
A communication entity represents a template for a communication between two ports. The communication has
a direction going from provided port to required port.

## GET /api/communication

### Description
Returns a list of all communication entities.

### Request Parameters
None

### Response
A list of all communication entities stored in the database.

### Response Example

```json
[
   {
      "links":[
         {
            "href":"http://example.com:9000/api/communication/1",
            "rel":"self"
         }
      ],
      "requiredPort":1,
      "providedPort":2
   },
   {
      "links":[
         {
            "href":"http://example.com:9000/api/communication/2",
            "rel":"self"
         }
      ],
      "requiredPort":1,
      "providedPort":2
   }
]
```

### Response Codes

**Normal Response Code** 200

**Error Response Code** 500 (server error), 403 (forbidden), 401 (unauthorized)

## GET /api/communication/{communication}

### Description

Returns the communication entity identified by the given {communication_id}.

### Request Parameters

Parameter        | Description
---------------- | -----------------------------------
communication_id | The id of the communication.
{: .table .table-striped .table-responsive}

### Response
Shows the selected comunication entity.

### Response Example
```
{
   "links":[
      {
         "href":"http://example.com:9000/api/communication/1",
         "rel":"self"
      }
   ],
   "requiredPort":1,
   "providedPort":2
}
```

### Response Codes

**Normal Response Code** 200

**Error Response Code** 500 (server error), 403 (forbidden), 401 (unauthorized), 404 (not found)

## POST /api/communication

### Description
Creates a new communication entity. The created entity will be returned.

### Request Parameters

Parameter | Description
--------- | -------------
requiredPort  | The port on the requiring side.
providedPort  | The port on the providing side.
{: .table .table-striped .table-responsive}

### Request Example
```json
{  
   "requiredPort":1,
   "providedPort":2
}
```

### Response

The created entity. See GET /api/communication/{communication_id}

### Response Codes

**Normal Response Code** 200

**Error Response Code** 500 (server error), 403 (forbidden), 401 (unauthorized), 400 (bad request)

## PUT /api/communication/{communication_id}

### Description
Updates the communication entity identified by the given id.

### Request Parameters

Parameter        | Description
---------------- | ------------------------------
communication_id | The id of the communication.
requiredPort  | The port on the requiring side.
providedPort  | The port on the providing side.
{: .table .table-striped .table-responsive}

### Request Example
```
PUT /api/communication/1
```
```json
{  
    "requiredPort":1,
    "providedPort":2
}
```

### Response

The updated entity. See GET /api/communication/{communication_id}

### Response Codes
**Normal Response Code** 200

**Error Response Code** 500 (server error), 403 (forbidden), 401 (unauthorized), 404 (not found), 400 (bad request)

## DELETE /api/communication/{communication_id}

### Description
Deletes the communication entity identified by the given id.

### Request Parameters 

Parameter        | Description
---------------- | ------------------------------
communication_id | The id of the communication.
{: .table .table-striped .table-responsive}

### Response Codes

**Normal Response Code** 200

**Error Response Code** 500 (server error), 403 (forbidden), 401 (unauthorized), 404 (not found)
