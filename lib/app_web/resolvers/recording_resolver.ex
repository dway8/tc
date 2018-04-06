defmodule AppWeb.RecordingResolver do
  alias App.Repo
  alias AppWeb.Recording
  alias AppWeb.Theme

  def all(_args, _info) do
    {:ok, Repo.all(Recording)}
  end

  def find(%{id: id}, _info) do
    case Repo.get(Recording, id) do
      nil -> {:error, "Recording id #{id} not found"}
      recording -> {:ok, recording}
    end
  end

  def create(args, _info) do
    theme = Repo.get_by!(Theme, name: args[:theme])
    args = Map.put(args, :theme_id, theme.id)

    %Recording{}
    |> Recording.changeset(args)
    |> Repo.insert()
  end

  def update(%{id: id, recording: post_params}, _info) do
    theme = Repo.get_by!(Theme, name: post_params[:theme])

    params =
      post_params
      |> Map.put(:theme_id, theme.id)
      |> Map.update!(:coordinates, fn c -> %Geo.Point{coordinates: {c.lng, c.lat}, srid: 4326} end)

    Repo.get!(Recording, id)
    |> Recording.changeset(params)
    |> Repo.update()
  end

  def delete(%{id: id}, _info) do
    recording = Repo.get!(Recording, id)
    Repo.delete(recording)
  end
end
