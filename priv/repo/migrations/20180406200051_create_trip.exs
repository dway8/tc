defmodule App.Repo.Migrations.CreateTrip do
  use Ecto.Migration

  def change do

    create table(:trips) do
      add :email, :string, null: false
      timestamps()
    end

    alter table(:recordings) do
      add :trip_id, references(:trips)
    end

  end
end
