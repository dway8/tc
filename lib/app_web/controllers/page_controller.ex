defmodule AppWeb.PageController do
  use AppWeb, :controller

  # def index(conn, _params) do
  #   render conn, "index.html"
  # end

  alias AppWeb.Auth
  alias AppWeb.User
  alias AppWeb.Auth.Guardian

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def login(conn, _params) do
    changeset = Auth.change_user(%User{})

    conn
    |> render(
      "login.html",
      changeset: changeset,
      action: page_path(conn, :login_user)
    )
  end

  def login_user(conn, %{"user" => %{"email" => email, "password" => password}}) do
    Auth.authenticate_user(email, password)
    |> login_reply(conn)
  end

  defp login_reply({:error, error}, conn) do
    conn
    |> put_flash(:error, error)
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/admin")
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: page_path(conn, :index))
  end

  def admin(conn, _params) do
    render(conn, "admin.html")
  end
end
