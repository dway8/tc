defmodule App.Repo.Migrations.UpdateRecordingAddress do
  use Ecto.Migration

  def change do

    execute "CREATE EXTENSION IF NOT EXISTS postgis"

    alter table(:recordings) do
      add :search_address, :string
      add :address, :string
      add :city, :string
    end

    # Add a field `coordinates` with type `geometry(Point,4326)`.
    # This can store a "standard GPS" (epsg4326) coordinate pair {longitude,latitude}.
    execute("SELECT AddGeometryColumn ('recordings','coordinates',4326,'POINT',2)")
    execute("CREATE INDEX recordings_coordinates_index on recordings USING gist (coordinates)")


  end
end
