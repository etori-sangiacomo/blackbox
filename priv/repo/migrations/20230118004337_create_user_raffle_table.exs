defmodule Blackbox.Repo.Migrations.CreateUsersRaffles do
  use Ecto.Migration

  def up do
    create table(:users_raffles, primary_key: false) do
      add(:raffle_id, references(:raffles, on_delete: :delete_all, type: :binary_id),
        primary_key: true
      )

      add(:user_id, references(:users, on_delete: :delete_all, type: :binary_id),
        primary_key: true
      )

      timestamps()
    end

    create(
      unique_index(:users_raffles, [:user_id, :raffle_id], name: :user_id_raffle_id_unique_index)
    )
  end

  def down do
    drop(table(:users_raffles))
  end
end
