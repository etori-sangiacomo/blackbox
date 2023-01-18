defmodule Blackbox.Domain.Accounts.Services.UserCreateService do
  @moduledoc """
  Service to create an user
  """

  alias Blackbox.Domain.Accounts
  alias BlackboxWeb.Actions.UserCreateAction

  @spec call(UserCreateAction.t()) :: {:ok, User.t()} | {:error, Error.t()}
  def call(%UserCreateAction{} = params) do
    params
    |> Map.from_struct()
    |> Accounts.create_user()
  end
end
