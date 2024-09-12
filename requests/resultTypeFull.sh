#!/bin/bash

# Function to fetch the sequence value for a given checkpoint
get_seq_for_checkpoint() {
  local checkpoint=$1
  curl -s -X GET "http://localhost:9200/checkpoint/_search" -H 'Content-Type: application/json' -d"
  {
    \"query\": {
      \"term\": { \"CHECKPOINT.keyword\": \"$checkpoint\" }
    },
    \"_source\": [\"SEQ\"]
  }" | jq -r '.hits.hits[0]._source.SEQ'
}

# Check if a checkpoint value is provided as an argument
if [ -n "$1" ]; then
  provided_checkpoint=$1
  seq=$(get_seq_for_checkpoint "$provided_checkpoint")
  checkPoint=$provided_checkpoint
else
  # Fetch the highest SEQ value and corresponding CHECKPOINT from the checkpoint index
  last_checkpoint=$(curl -s -X GET "http://localhost:9200/checkpoint/_search" -H 'Content-Type: application/json' -d'
  {
    "size": 1,
    "sort": [{ "SEQ": "desc" }],
    "_source": ["CHECKPOINT", "SEQ"]
  }' | jq -c '.hits.hits[0] | {checkPoint: ._source.CHECKPOINT, seq: ._source.SEQ}')

  # Extract the sequence and checkpoint values
  seq=$(echo "$last_checkpoint" | jq -r '.seq')
  checkPoint=$(echo "$last_checkpoint" | jq -r '.checkPoint')
fi

# Fetch audit logs for SEQ values less than or equal to the provided or highest SEQ value
audit_logs=$(curl -s -X GET "http://localhost:9200/audit/_search" -H 'Content-Type: application/json' -d @- <<EOF
{
  "size": 1000,
  "query": {
    "range": {
      "SEQ": {
        "lte": $seq
      }
    }
  },
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
}
EOF
)

# Process the audit logs with jq for summary
summary=$(echo "$audit_logs" | jq -r '{
  summaryOfChangedItems: [
    if .aggregations.deletedItems.doc_count > 0 then { "number of deletedItems": .aggregations.deletedItems.doc_count } else empty end,
    if .aggregations.changedItems.doc_count > 0 then { "number of changedItems": .aggregations.changedItems.doc_count } else empty end,
    if .aggregations.insertedItems.doc_count > 0 then { "number of insertedItems": .aggregations.insertedItems.doc_count } else empty end
  ]
}')

# Process the audit logs with jq for details
details=$(echo "$audit_logs" | jq -r '{
  changedItems: [.hits.hits[] | select(._source.OPERATION == "PUT") | ._source.PAYLOAD],
  deletedItems: [.hits.hits[] | select(._source.OPERATION == "DELETE") | {featureID: (._source.FEATURE_COLLECTION_ID + "/" + (._source.FEATURE_ID // ""))}],
  insertedItems: [.hits.hits[] | select(._source.OPERATION == "POST") | ._source.PAYLOAD]
} | with_entries(select(.value | length > 0))')

# Combine the results into a single JSON object
result=$(jq -n --arg checkPoint "$checkPoint" --argjson summary "$summary" --argjson details "$details" '{
  checkPoint: $checkPoint,
  summaryOfChangedItems: $summary.summaryOfChangedItems
} + $details')

# Output the result
echo "$result"
