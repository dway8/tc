defmodule AppWeb.Recording do
  use AppWeb, :model
  alias AppWeb.Theme
  alias AppWeb.Trip

  schema "recordings" do
    field(:author, :string)
    field(:description, :string)
    belongs_to(:theme, Theme)
    field(:coordinates, Geo.Point)
    field(:search_address, :string)
    field(:address, :string)
    field(:city, :string)
    belongs_to(:trip, Trip)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :author,
      :description,
      :theme_id,
      :search_address,
      :address,
      :city,
      :coordinates
    ])
    |> validate_required([:author, :description])
  end
end
