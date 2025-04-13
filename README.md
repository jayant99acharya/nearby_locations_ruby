# Nearby Locations API

A Ruby on Rails API for managing and searching location data based on categories and proximity.

## Features

- Create locations with name, address, coordinates, and category
- List locations by category
- Search for nearby locations within a specified radius
- Calculate trip costs between locations (mock implementation)
- Response time measurement for all endpoints

## Requirements

- Ruby 3.2.2
- PostgreSQL
- Docker (optional)

## Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd nearby_locations_api
```

2. Install dependencies:
```bash
bundle install
```

3. Set up the database:
```bash
rails db:create db:migrate
```

4. Start the server:
```bash
rails server
```

## Docker Setup

1. Build the Docker image:
```bash
docker build -t nearby-locations-api .
```

2. Run the container:
```bash
docker run -p 3000:3000 nearby-locations-api
```

## API Endpoints

### Create Location
```
POST /api/v1/locations
Content-Type: application/json

{
  "location": {
    "name": "Hospital XYZ",
    "address": "123 Main Street",
    "latitude": 37.783333,
    "longitude": -122.416667,
    "category": "hospital"
  }
}
```

### Get Locations by Category
```
GET /api/v1/locations/:category
```

### Search Nearby Locations
```
POST /api/v1/locations/search
Content-Type: application/json

{
  "latitude": 37.783333,
  "longitude": -122.416667,
  "category": "cafe",
  "radius_km": 2
}
```

### Get Trip Cost
```
POST /api/v1/locations/:id/trip-cost
Content-Type: application/json

{
  "latitude": 37.783333,
  "longitude": -122.416667
}
```

## Environment Variables

- `DATABASE_URL`: PostgreSQL connection URL (required in production)
- `TOLLGURU_API_KEY`: TollGuru API key (required for trip cost calculation)

## Testing

Run the test suite:
```bash
rails test
```

## API Endpoints
```bash
curl -X POST -H "Content-Type: application/json" -d '{"location": {"name": "Hospital XYZ", "address": "123 Main Street", "latitude": 37.783333, "longitude": -122.416667, "category": "hospital"}}' http://localhost:3000/api/v1/locations

curl http://localhost:3000/api/v1/locations/hospital

curl -X POST -H "Content-Type: application/json" -d '{"latitude": 37.783333, "longitude": -122.416667, "category": "hospital", "radius_km": 2}' http://localhost:3000/api/v1/locations/search
```

## License

MIT License
