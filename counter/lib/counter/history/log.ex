defmodule Counter.History.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :name, :string
    field :count, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:name, :count])
    |> validate_required([:name, :count])
  end
end
