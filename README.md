# pygeoapi Delta Updates demo implementation

This is a demo implementation of [OGC Testbed-15: Delta Updates (OGC 19-012r1)](https://docs.ogc.org/per/19-012r1.html)  

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

    a. Get the `ChangeSet` summary: `./requests/resultTypeSummary.sh`
    b. Get the `ChangeSet` restricted to a specific `checkPoint`: `./requests/resultTypeSummary.sh <checkPointId>`
    c. Get the Full `ChangeSet`: `./requests/resultTypeFull.sh`
    d. Get the Full `ChangeSet` restricted to a specific `checkPoint`: `./requests/resultTypeFull.sh <checkPointId>`

> [IMPORTANT!]
The `/changeset` path and the `resultType` parameter will be added to the API in a future development stage. For now, the requests are made directly to the database.
