defmodule App.Repo.Migrations.CreateTheme do
  use Ecto.Migration

  def change do

    create table(:themes) do
      add :name, :string
      timestamps()
      end

    alter table(:recordings) do
      add :theme_id, references(:themes)
    end

  end
end
