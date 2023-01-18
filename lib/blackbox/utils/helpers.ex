defmodule Blackbox.Utils.Helpers do
  @moduledoc """
  Helpers functions
  """

  def unix_date_time_now(), do: DateTime.utc_now() |> DateTime.to_unix(:second)
  def is_expired?(date), do: date <= unix_date_time_now()
  def date_from_unix(date), do: DateTime.from_unix(date)
end
