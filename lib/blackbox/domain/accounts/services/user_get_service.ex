defmodule Blackbox.Domain.Accounts.Services.UserGetService do
  @moduledoc """
  Service to show an user
  """

  alias Blackbox.Domain.Accounts
  alias BlackboxWeb.Actions.UserShowAction

  @spec call(UserShowAction.t()) :: User.t() | term() | nil
  def call(%UserShowAction{} = params), do: Accounts.get_user(params.id)
end
