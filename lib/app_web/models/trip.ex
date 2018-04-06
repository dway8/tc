defmodule AppWeb.Trip do
  use AppWeb, :model
  alias AppWeb.Recording

  schema "trips" do
    has_many(:recordings, Recording)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
  end
end
