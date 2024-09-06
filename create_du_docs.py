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
        'checkpoint': { 'type': 'keyword' },
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
