defmodule Blackbox.Utils.EctoTypes.DowncaseString do
  @moduledoc """
  Return an downcase string
  """

  use Ecto.Type

  def type,
    do: :string

  def cast(str) when is_binary(str),
    do: {:ok, to_downcase(str)}

  def cast(_), do: :error

  def load(str),
    do: Ecto.Type.load(:string, str)

  def dump(str),
    do: Ecto.Type.dump(:string, str)

  defp to_downcase(str) do
    str
    |> String.trim(" ")
    |> String.downcase()
  end
end
