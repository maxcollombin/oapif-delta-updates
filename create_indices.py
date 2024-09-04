import json
from elasticsearch import Elasticsearch, helpers
from datetime import datetime

# Initialize Elasticsearch client
es = Elasticsearch('http://elasticsearch:9200')

# Define audit and checkpoint index settings and mappings
audit_settings = {
    'number_of_shards': 1,
    'number_of_replicas': 0
}

audit_mappings = {
    'properties': {
        'seq': { 'type': 'integer' },
        'txid': { 'type': 'keyword' },
        'timestamp_': { 'type': 'date', 'format': 'strict_date_optional_time||epoch_millis' },
        'feature_collection_id': { 'type': 'keyword' },
        'feature_id': { 'type': 'keyword' },
        'operation': { 'type': 'keyword' }
    }
}

checkpoint_settings = {
    'number_of_shards': 1,
    'number_of_replicas': 0
}

checkpoint_mappings = {
    'properties': {
        'checkpoint_': { 'type': 'keyword' },
        'feature_collection_id': { 'type': 'keyword' },
        'seq': { 'type': 'integer' }
    }
}

# Create audit index if it doesn't exist
if not es.indices.exists(index='audit'):
    es.indices.create(index='audit', settings=audit_settings, mappings=audit_mappings)

# Create checkpoint index if it doesn't exist
if not es.indices.exists(index='checkpoint'):
    es.indices.create(index='checkpoint', settings=checkpoint_settings, mappings=checkpoint_mappings)

# Generate sample documents for audit index
audit_docs = [
    {
        "_index": "audit",
        "_source": {
            "seq": i,
            "txid": f"tx{i}",
            "timestamp_": datetime.now().isoformat(),
            "feature_collection_id": f"fc{i}",
            "feature_id": f"f{i}",
            "operation": "create"
        }
    }
    for i in range(1, 11)  # Generate 10 sample documents
]

# Generate sample documents for checkpoint index
checkpoint_docs = [
    {
        "_index": "checkpoint",
        "_source": {
            "checkpoint_": f"cp{i}",
            "feature_collection_id": f"fc{i}",
            "seq": i
        }
    }
    for i in range(1, 11)  # Generate 10 sample documents
]

# Index the audit and checkpoint documents
helpers.bulk(es, audit_docs)
helpers.bulk(es, checkpoint_docs)