defmodule Blackbox.Utils.EctoTypes.TitlecaseString do
  @moduledoc """
  Return an titlecase string
  """

  use Ecto.Type

  def type,
    do: :string

  def cast(str) when is_binary(str),
    do: {:ok, to_titlecase(str)}

  def cast(_), do: :error

  def load(str),
    do: Ecto.Type.load(:string, str)

  def dump(str),
    do: Ecto.Type.dump(:string, str)

  defp to_titlecase(str) do
    str
    |> String.trim(" ")
    |> String.split(" ")
    |> Enum.map_join(" ", &String.capitalize/1)
  end
end
