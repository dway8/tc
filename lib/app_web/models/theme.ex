defmodule AppWeb.Theme do
  use AppWeb, :model
  alias AppWeb.Recording

  schema "themes" do
    field :name, :string
    has_many :recordings, Recording

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
