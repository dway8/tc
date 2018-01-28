defmodule AppWeb.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: App.Repo

  object :recording do
    field :id, :id
    field :author, :string
    field :description, :string
    field :theme, :theme, resolve: assoc(:theme)
  end

  object :theme do
    field :id, :id
    field :name, :string
    field :recordings, list_of(:recording), resolve: assoc(:recordings)
  end
end
