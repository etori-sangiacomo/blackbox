defmodule BlackboxWeb.Actions.UserCreateAction do
  @moduledoc """
  DTO to validate request fields
  """
  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key false

  @required_fields ~w(email name)a
  @optional_fields ~w()a

  embedded_schema do
    field(:email, :string)
    field(:name, :string)
  end

  def changeset(schema \\ %__MODULE__{}, attrs) do
    schema
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 2, max: 30)
    |> validate_format(:email, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
  end
end
