class Location < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :category, presence: true

  def self.nearby(lat, lon, category, radius_km)
    # Earth's radius in kilometers
    earth_radius = 6371

    # Build the distance calculation SQL
    distance_sql = <<-SQL.squish
      #{earth_radius} * 2 * ASIN(
        SQRT(
          POWER(SIN((RADIANS(#{lat}) - RADIANS(latitude)) / 2), 2) +
          COS(RADIANS(#{lat})) * COS(RADIANS(latitude)) *
          POWER(SIN((RADIANS(#{lon}) - RADIANS(longitude)) / 2), 2)
        )
      )
    SQL

    # Use a CTE (Common Table Expression) to calculate distances
    sql = <<-SQL.squish
      WITH locations_with_distance AS (
        SELECT *, (#{distance_sql}) as calculated_distance
        FROM locations
        WHERE category = '#{category}'
      )
      SELECT *
      FROM locations_with_distance
      WHERE calculated_distance <= #{radius_km}
      ORDER BY calculated_distance
    SQL

    # Execute the raw SQL and map the results
    results = connection.execute(sql)
    results.map do |row|
      {
        id: row['id'],
        name: row['name'],
        address: row['address'],
        distance: row['calculated_distance'].to_f.round(2),
        category: row['category']
      }
    end
  end
end
