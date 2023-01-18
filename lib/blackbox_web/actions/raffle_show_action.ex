defmodule BlackboxWeb.Actions.RaffleShowAction do
  @moduledoc """
  DTO to validate request fields
  """
  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key false

  @required_fields ~w(id)a
  @optional_fields ~w(winner)a

  embedded_schema do
    field(:id, Ecto.UUID)
    field(:winner, :boolean, default: true)
  end

  def changeset(schema \\ %__MODULE__{}, attrs) do
    schema
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
