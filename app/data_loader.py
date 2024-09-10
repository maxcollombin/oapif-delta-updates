import json
import yaml
from pathlib import Path
from elasticsearch import Elasticsearch, helpers

# Load configuration from config.yml file
with open('/app/elastic.config.yml', 'r', encoding='utf-8') as config_file:
    config = yaml.safe_load(config_file)

# Initialize Elasticsearch client
es = Elasticsearch('http://elasticsearch:9200')

for file_config in config['files']:
    geojson_file = file_config['path']
    id_field = file_config['id_field']
    index_name = Path(geojson_file).stem.lower()

    # Read the GeoJSON file to determine the geometry type
    with open(geojson_file, 'r', encoding='utf-8') as file:
        geojson_data = json.load(file)
        first_feature = geojson_data['features'][0]
        geometry_type = first_feature['geometry']['type']

    # Delete the index if it already exists
    if es.indices.exists(index=index_name):
        es.indices.delete(index=index_name)

    # Define index settings and mappings
    settings = {
        'number_of_shards': 1,
        'number_of_replicas': 0
    }

    mappings = {
        'properties': {
            'geometry': {
                'type': 'geo_shape'
            },
            'properties': {
                'properties': {
                    'nameascii': {
                        'type': 'text',
                        'fields': {
                            'raw': {
                                'type': 'keyword'
                            }
                        }
                    }
                }
            }
        }
    }

    # Create the index
    es.indices.create(index=index_name, settings=settings, mappings=mappings)

    # Generator function to yield features
    def gendata(data):
        for feature in data['features']:
            # Check if the ID field is in the properties or as a direct id
            if id_field in feature['properties']:
                feature_id = feature['properties'][id_field]
            elif id_field in feature:
                feature_id = feature[id_field]
            else:
                print(f"Warning: ID field '{id_field}' not found in feature")
                continue

            try:
                feature_id = int(feature_id)
            except ValueError:
                pass

            yield {
                "_index": index_name,
                "_id": feature_id,
                "_source": feature
            }

    # Index the data
    helpers.bulk(es, gendata(geojson_data))
    