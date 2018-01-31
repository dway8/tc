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
    %Recording{}
    |> Recording.changeset(args)
    |> Repo.insert
  end

  def update(%{id: id, recording: post_params}, _info) do
    theme = Repo.get_by!(Theme, name: post_params[:theme])
    params = Map.put(post_params, :theme_id, theme.id)
    Repo.get!(Recording, id)
    |> Recording.changeset(params)
    |> Repo.update
  end

  def delete(%{id: id}, _info) do
    recording = Repo.get!(Recording, id)
    Repo.delete(recording)
  end

end
