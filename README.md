# pygeoapi Delta Updates demo implementation

This is a demo implementation of [OGC Testbed-15: Delta Updates (OGC 19-012r1)](https://docs.ogc.org/per/19-012r1.html)  

## Start the containers

```bash
docker compose up --build -d
```

Alternatively, you can start the containers with the following shell script:

```bash
./start.sh
```

## Stop the containers

```bash
docker compose down
```

Alternatively, you can stop the containers with the following shell script (which will also remove the containers, volumes and elasticsearch related content):

```bash
./stop.sh
```

## Access the pygeoapi endpoint

The API is available at [http://localhost:5000](http://localhost:5000)

## CRUD operations

Elasticsearch is one on the two pygeoapi data providers that support CRUD operations (see [pygeoapi documentation](https://docs.pygeoapi.io/en/latest/data-publishing/ogcapi-features.html#ogcapi-features) for more information).

### GET operation

Get the first item of the `obs` collection:

```bash
curl -X GET http://localhost:5000/collections/obs/items/0 | jq 'del(.links)' > output.geojson
```

> [!NOTE]
The `jq` command is used to retrieve the response without the `links` object.

### DELETE operation

Delete the first item of the `obs` collection:

```bash
curl -X DELETE http://localhost:5000/collections/obs/items/0
```

### POST operation

Add the deleted item back to the `obs` collection:

### PUT operation

Update the first item of the `obs` collection:

```bash
curl -X PUT -H "Content-Type: application/json" -d @output.geojson http://localhost:5000/collections/obs/items/1
```

> [!IMPORTANT]
The `PUT` operation requires the whole item content to be sent in the request body.

### PATCH operation

The `PATCH` operation is not supported by the elasticsearch data provider.
