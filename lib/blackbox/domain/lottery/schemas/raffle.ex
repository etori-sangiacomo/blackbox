defmodule Blackbox.Domain.Lottery.Schemas.Raffle do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Blackbox.Domain.Accounts.Schemas.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_fields ~w(name date)a
  @optional_fields ~w(winner_id status)a
  @status ~w(created processed)a

  schema "raffles" do
    field :date, :utc_datetime
    field :name, :string
    field :status, Ecto.Enum, values: @status, null: false, default: :created

    belongs_to :winner, User

    many_to_many(:users, User,
      join_through: "users_raffles",
      on_replace: :delete,
      on_delete: :delete_all
    )

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(raffle, attrs) do
    raffle
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
