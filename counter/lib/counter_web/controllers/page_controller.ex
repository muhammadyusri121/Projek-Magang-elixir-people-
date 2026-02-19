defmodule CounterWeb.PageController do
  use CounterWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
