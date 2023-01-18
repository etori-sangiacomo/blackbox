defmodule BlackboxWeb.UserController do
  use BlackboxWeb, :controller

  alias Blackbox.Domain.Accounts.Services.UserCreateService
  alias Blackbox.Domain.Accounts.Schemas.User
  alias BlackboxWeb.Actions.UserCreateAction
  alias Blackbox.Utils.Changesets

  action_fallback BlackboxWeb.FallbackController

  def create(conn, %{"user" => params}) do
    with {:ok, changeset} <- Changesets.cast_and_apply(UserCreateAction, params),
         {:ok, %User{} = user} <- UserCreateService.call(changeset) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end
end
