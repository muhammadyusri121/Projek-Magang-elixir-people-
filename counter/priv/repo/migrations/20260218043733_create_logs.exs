defmodule Counter.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :name, :string
      add :count, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
