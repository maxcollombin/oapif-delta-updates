#!/bin/bash

curl -X GET "http://localhost:9200/audit/_search" -H 'Content-Type: application/json' -d'
{
  "size": 0,
  "aggs": {
    "deletedItems": {
      "filter": { "term": { "OPERATION.keyword": "DELETE" } }
    },
    "changedItems": {
      "filter": { "term": { "OPERATION.keyword": "PUT" } }
    },
    "insertedItems": {
      "filter": { "term": { "OPERATION.keyword": "POST" } }
    }
  }
}' | jq -r '{
  summaryOfChangedItems: [
    if .aggregations.deletedItems.doc_count > 0 then { "number of deletedItems": .aggregations.deletedItems.doc_count } else empty end,
    if .aggregations.changedItems.doc_count > 0 then { "number of changedItems": .aggregations.changedItems.doc_count } else empty end,
    if .aggregations.insertedItems.doc_count > 0 then { "number of insertedItems": .aggregations.insertedItems.doc_count } else empty end
  ]
}'
