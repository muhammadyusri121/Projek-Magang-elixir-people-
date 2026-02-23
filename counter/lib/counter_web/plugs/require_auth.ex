defmodule CounterWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    if get_session(conn, :current_user) do
      conn
    else
      conn
      |> put_flash(:error, "Anda harus login terlebih dahulu.")
      |> redirect(to: "/login")
      |> halt()
    end
  end
end
