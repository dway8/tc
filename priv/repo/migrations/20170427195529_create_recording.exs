defmodule App.Repo.Migrations.CreateRecording do
  use Ecto.Migration

  def change do
    create table(:recordings) do
      add :author, :string
      add :description, :text

      timestamps()
    end

  end
end
