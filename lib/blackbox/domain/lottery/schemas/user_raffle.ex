defmodule Blackbox.Domain.Lottery.Schemas.UserRaffle do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Blackbox.Domain.Accounts.Schemas.User
  alias Blackbox.Domain.Lottery.Schemas.Raffle

  @required_fields ~w(user_id raffle_id)a
  @primary_key false

  schema "users_raffles" do
    belongs_to(:user, User, type: :binary_id)
    belongs_to(:raffle, Raffle, type: :binary_id)

    timestamps(type: :utc_datetime)
  end

  def changeset(user_raffle, params \\ %{}) do
    user_raffle
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:raffle_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:user, :raffle],
      name: :users_raffles_pkey
    )
  end
end
