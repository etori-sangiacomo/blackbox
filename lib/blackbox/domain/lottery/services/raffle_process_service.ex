defmodule Blackbox.Domain.Lottery.Services.RaffleProcessService do
  @moduledoc """
  Service to run a raffle
  """

  alias Blackbox.Domain.Lottery
  alias Lottery.Services.RaffleGetService
  alias Blackbox.Domain.Lottery.Schemas.Raffle
  alias BlackboxWeb.Actions.RaffleShowAction
  alias Blackbox.Utils.Changesets
  alias BlackboxWeb.Actions.RaffleShowAction

  require Logger

  @spec call(RaffleShowAction.t()) :: {:ok, Raffle.t()} | {:error, Error.t()}
  def call(%RaffleShowAction{id: id}) do
    Logger.info("Processing raffle_id: #{id}")

    with {:ok, changeset} <-
           Changesets.cast_and_apply(RaffleShowAction, %{id: id, winner: false}),
         {:ok, %Raffle{} = raffle} <- RaffleGetService.call(changeset),
         {:ok, user_id} <- raffle.id |> Lottery.list_users_raffle() |> random() do
      Lottery.update_raffle(raffle, user_id |> build_attrs())
    else
      nil ->
        Logger.error("Event error - raffle processing service: #{id}")
        {:error, :not_found}

      error ->
        Logger.error("Event error - raffle processing service: #{inspect(error)}")
        error
    end
  end

  defp random([]), do: {:ok, nil}
  defp random(user_ids) when length(user_ids) < 2, do: {:ok, List.first(user_ids)}
  defp random(user_ids), do: {:ok, user_ids |> Enum.random()}

  defp build_attrs(nil = _user_id), do: %{status: "processed"}
  defp build_attrs(user_id), do: %{winner_id: user_id, status: "processed"}
end
