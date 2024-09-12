# OGC Delta Updates pygeoapi demo implementation

This is a demo implementation of [OGC Testbed-15: Delta Updates (OGC 19-012r1)](https://docs.ogc.org/per/19-012r1.html)  with OGC API - Features using [pygeoapi](https://pygeoapi.io/).

## Start the containers

```bash
./start.sh
```

## Stop the containers

```bash
./stop.sh
```

## Requests

1. Delete an existing feature: `./requests/deleteItem.sh`
2. Add a new feature: `./requests/addItem.sh`
3. `ChangeSet` Requests
    1. Get the `ChangeSet` summary: `./requests/resultTypeSummary.sh`
    2. Get the `ChangeSet` restricted to a specific `checkPoint`: `./requests/resultTypeSummary.sh <checkPointId>`
    3. Get the Full `ChangeSet`: `./requests/resultTypeFull.sh`
    4. Get the Full `ChangeSet` restricted to a specific `checkPoint`: `./requests/resultTypeFull.sh <checkPointId>`

> [!IMPORTANT]
The `/changeset` path and the `resultType` parameter will be added to the API in a future development stage. For now, the requests are made directly to the database.
