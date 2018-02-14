defmodule AppWeb.Auth.ErrorHandler do
  import Plug.Conn
  import Phoenix.Controller

  def auth_error(conn, {type, reason}, _opts) do
    conn
    |> redirect(to: "/")
  end
end
