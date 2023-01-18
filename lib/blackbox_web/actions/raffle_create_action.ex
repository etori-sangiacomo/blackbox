defmodule BlackboxWeb.Actions.RaffleCreateAction do
  @moduledoc """
  DTO to validate request fields
  """
  # alias Phoenix.Router.Helpers
  alias Blackbox.Utils.Helpers
  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key false

  @required_fields ~w(name date)a
  @optional_fields ~w()a

  embedded_schema do
    field(:date, :integer)
    field(:name, :string)
  end

  def changeset(schema \\ %__MODULE__{}, attrs) do
    schema
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 1, max: 30)
    |> validate_datetime()
  end

  defp validate_datetime(%Ecto.Changeset{changes: %{date: date}} = changeset) do
    case Helpers.is_expired?(date) do
      true ->
        %{changeset | errors: [{:date, {"Expired", :date}}], valid?: false}

      false ->
        changeset
    end
  end

  defp validate_datetime(changeset), do: changeset
end
