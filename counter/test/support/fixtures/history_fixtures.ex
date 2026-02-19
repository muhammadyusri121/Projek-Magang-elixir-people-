defmodule Counter.HistoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Counter.History` context.
  """

  @doc """
  Generate a log.
  """
  def log_fixture(attrs \\ %{}) do
    {:ok, log} =
      attrs
      |> Enum.into(%{
        count: 42,
        name: "some name"
      })
      |> Counter.History.create_log()

    log
  end
end
