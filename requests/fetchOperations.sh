curl -X GET "http://localhost:9200/audit/_search" -H 'Content-Type: application/json' -d'
{
  "size": 0,
  "aggs": {
    "operations": {
      "terms": {
        "field": "TXID.keyword",
        "size": 10
      },
      "aggs": {
        "operation_details": {
          "top_hits": {
            "_source": ["TXID", "OPERATION", "FEATURE_COLLECTION_ID"],
            "size": 1
          }
        },
        "feature_count": {
          "value_count": {
            "field": "FEATURE_ID.keyword"
          }
        }
      }
    }
  }
}' | jq -r '.aggregations.operations.buckets[] | "ACTION \(.key): \(.operation_details.hits.hits[0]._source.OPERATION) \(.feature_count.value) feature(s) in the \(.operation_details.hits.hits[0]._source.FEATURE_COLLECTION_ID) collection;"'
