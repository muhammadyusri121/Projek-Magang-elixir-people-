defmodule CounterWeb.AuthController do
  use CounterWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_info = %{
      email: auth.info.email,
      name: auth.info.name,
      avatar: auth.info.image,
      provider_id: auth.uid
    }

    conn
    |> put_flash(:info, "Berhasil login sebagai #{user_info.name}!")
    |> put_session(:current_user, user_info)
    |> redirect(to: ~p"/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Gagal login dengan Google.")
    |> redirect(to: ~p"/")
  end

  def logout(conn, _params) do
    conn
    |> clear_session()
    |> put_flash(:info, "Berhasil logout.")
    |> redirect(to: ~p"/")
  end
end
