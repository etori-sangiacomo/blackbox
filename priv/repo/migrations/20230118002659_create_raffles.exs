defmodule Blackbox.Repo.Migrations.CreateRaffles do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE raffle_status AS ENUM ('created', 'processed')")

    create table(:raffles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :date, :utc_datetime, null: false
      add :winner_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :status, :raffle_status, null: false, default: "created"

      timestamps(type: :utc_datetime)
    end

    create index(:raffles, [:winner_id])
  end

  def down do
    drop(table(:raffles))
  end
end
