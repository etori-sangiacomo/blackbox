defmodule Blackbox.Domain.Accounts.Schemas.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Blackbox.Utils.EctoTypes.{DowncaseString, TitlecaseString}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_fields ~w(email name)a
  @optional_fields ~w()a

  schema "users" do
    field :email, DowncaseString
    field :name, TitlecaseString

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
  end
end
