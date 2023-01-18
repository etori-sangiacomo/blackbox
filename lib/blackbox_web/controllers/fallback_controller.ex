defmodule BlackboxWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use BlackboxWeb, :controller

  def call(conn, error) do
    errors =
      error
      |> BlackboxWeb.Utils.Error.normalize()
      |> List.wrap()

    status = hd(errors).status_code
    messages = Enum.map(errors, & &1.message)

    conn
    |> put_status(status)
    |> json(%{errors: messages})
  end
end
