defmodule AppWeb.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: App.Repo

  object :recording do
    field(:id, :id)
    field(:author, :string)
    field(:description, :string)
    field(:theme, :theme, resolve: assoc(:theme))
    field(:search_address, :string)
    field(:address, :string)
    field(:city, :string)

    field :coordinates, :coordinates do
      resolve(fn recording, _, _ ->
        val = Geo.JSON.encode(recording.coordinates)
        {:ok, %{lat: List.last(val["coordinates"]), lng: List.first(val["coordinates"])}}
      end)
    end
  end

  object :theme do
    field(:id, :id)
    field(:name, :string)
    field(:recordings, list_of(:recording), resolve: assoc(:recordings))
  end

  object :coordinates do
    field(:lat, :float)
    field(:lng, :float)
  end
end
