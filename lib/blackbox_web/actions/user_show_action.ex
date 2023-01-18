defmodule BlackboxWeb.Actions.UserShowAction do
  @moduledoc """
  DTO to validate request fields
  """
  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key false

  @required_fields ~w(id)a
  @optional_fields ~w()a

  embedded_schema do
    field(:id, Ecto.UUID)
  end

  def changeset(schema \\ %__MODULE__{}, attrs) do
    schema
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
