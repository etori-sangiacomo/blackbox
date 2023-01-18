defmodule Blackbox.Domain.Lottery.Services.SubscribeService do
  @moduledoc """
  Service to subscriber an user into a raffle
  """

  alias BlackboxWeb.Actions.{SubscriptionAction, UserShowAction, RaffleShowAction}
  alias Blackbox.Domain.Accounts.Schemas.User
  alias Blackbox.Domain.Accounts.Services.UserGetService
  alias Blackbox.Domain.Lottery
  alias Lottery.Schemas.{Raffle, UserRaffle}
  alias Lottery.Services.RaffleGetService
  alias Blackbox.Utils.Changesets

  require Logger

  @spec call(SubscriptionAction.t()) :: {:ok, UserRaffle.t()} | {:error, Error.t()}
  def call(%SubscriptionAction{} = params) do
    with {:ok, changeset} <- Changesets.cast_and_apply(UserShowAction, %{id: params.user_id}),
         {:ok, %User{}} <- UserGetService.call(changeset),
         {:ok, changeset} <-
           Changesets.cast_and_apply(RaffleShowAction, %{id: params.raffle_id, winner: false}),
         {:ok, %Raffle{} = raffle} <- RaffleGetService.call(changeset),
         true <- raffle.status == :created do
      params
      |> Map.from_struct()
      |> Lottery.subscribe()
    else
      false ->
        {:error, :raffle_processed}

      error ->
        error
    end
  end
end
