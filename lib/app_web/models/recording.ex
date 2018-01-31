defmodule AppWeb.Recording do
  use AppWeb, :model
  alias AppWeb.Theme

  schema "recordings" do
    field :author, :string
    field :description, :string
    belongs_to :theme, Theme

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:author, :description, :theme_id])
    |> validate_required([:author, :description])
  end
end
