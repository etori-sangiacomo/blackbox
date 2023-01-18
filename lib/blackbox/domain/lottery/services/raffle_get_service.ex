defmodule Blackbox.Domain.Lottery.Services.RaffleGetService do
  @moduledoc """
  Service to show a raffle
  """

  alias BlackboxWeb.Actions.RaffleShowAction
  alias Blackbox.Domain.Lottery
  alias Lottery.Schemas.Raffle

  @spec call(RaffleShowAction.t()) :: {:ok, Raffle.t()} | {:error, Error.t()}
  def call(%RaffleShowAction{winner: true} = params), do: Lottery.get_winner(params.id)

  @spec call(RaffleShowAction.t()) :: {:ok, Raffle.t()} | {:error, Error.t()}
  def call(%RaffleShowAction{} = params), do: Lottery.get_raffle(params.id)
end
