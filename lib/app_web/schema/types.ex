defmodule AppWeb.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: App.Repo

  object :recording do
    field :id, :id
    field :author, :string
    field :description, :string
  end
end
