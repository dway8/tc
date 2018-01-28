defmodule AppWeb.ThemeResolver do
  alias App.Repo
  alias AppWeb.Theme

  def all(_args, _info) do
    {:ok, Repo.all(Theme)}
  end

  def find(%{id: id}, _info) do
    case Repo.get(Theme, id) do
      nil -> {:error, "Theme id #{id} not found"}
      theme -> {:ok, theme}
    end
  end

  def create(args, _info) do
    %Theme{}
    |> Theme.changeset(args)
    |> Repo.insert
  end

  def update(%{id: id, theme: post_params}, _info) do
    Repo.get!(Theme, id)
    |> Recording.changeset(post_params)
    |> Repo.update
  end

  def delete(%{id: id}, _info) do
    theme = Repo.get!(Theme, id)
    Repo.delete(theme)
  end

end

