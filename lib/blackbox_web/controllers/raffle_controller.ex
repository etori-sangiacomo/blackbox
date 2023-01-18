defmodule BlackboxWeb.RaffleController do
  use BlackboxWeb, :controller

  alias BlackboxWeb.Actions.{RaffleCreateAction, SubscriptionAction, RaffleShowAction}
  alias Blackbox.Domain.Lottery.Schemas.{Raffle, UserRaffle}
  alias Blackbox.Domain.Lottery.Services.{RaffleCreateService, RaffleGetService, SubscribeService}
  alias Blackbox.Utils.Changesets

  action_fallback BlackboxWeb.FallbackController

  def create(conn, %{"raffle" => params}) do
    with {:ok, changeset} <- Changesets.cast_and_apply(RaffleCreateAction, params),
         {:ok, %Raffle{} = raffle} <- RaffleCreateService.call(changeset) do
      conn
      |> put_status(:created)
      |> render("show.json", raffle: raffle)
    end
  end

  def create(conn, %{"subscribe" => params}) do
    with {:ok, changeset} <- Changesets.cast_and_apply(SubscriptionAction, params),
         {:ok, %UserRaffle{}} <- SubscribeService.call(changeset) do
      conn
      |> put_status(:created)
      |> json(%{data: "ok"})
    end
  end

  def show(conn, params) do
    with {:ok, changeset} <- Changesets.cast_and_apply(RaffleShowAction, params),
         {:ok, %Raffle{} = raffle} <- RaffleGetService.call(changeset) do
      conn
      |> put_status(:ok)
      |> render("show.json", winner: raffle)
    end
  end
end
