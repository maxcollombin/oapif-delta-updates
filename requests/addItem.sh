curl -X 'POST' \
  'http://localhost:5000/collections/obs/items' \
  -H 'accept: */*' \
  -H 'Content-Type: application/geo+json' \
  -d '{
  "type": "Feature",
  "id": 7,
  "properties": {
    "stn_id": 35,
    "datetime": "2002-10-30T18:31:38Z",
    "value": 93.9,
    "lat": 46.414543,
    "long": 6.927444
  },
  "geometry": {
    "type": "Point",
    "coordinates": [
      6.927444,
      46.414543
    ]
  }
}'
