defmodule Blackbox.Domain.Lottery.Services.RaffleCreateService do
  @moduledoc """
  Service to create a raffle
  """

  alias BlackboxWeb.Actions.RaffleCreateAction
  alias Blackbox.Domain.Lottery
  alias Lottery.Schemas.Raffle
  alias Blackbox.Domain.Lottery.Jobs.RaffleJob
  alias Blackbox.Utils.Helpers

  require Logger

  @spec call(RaffleCreateAction.t()) :: {:ok, Raffle.t()} | {:error, Error.t()}
  def call(%RaffleCreateAction{} = params) do
    with {:ok, %Raffle{} = raffle} <- Lottery.create_raffle(format_params(params)),
         {:ok, %Oban.Job{}} <- raffle_enqueue({:ok, raffle}) do
      {:ok, raffle}
    else
      true ->
        {:error, :raffle_date_expired}

      error ->
        error
    end
  end

  defp format_params(params) do
    {:ok, datetime} = Helpers.date_from_unix(params.date)

    params
    |> Map.from_struct()
    |> Map.put(:date, datetime)
  end

  def raffle_enqueue({:error, _reason} = error), do: error

  def raffle_enqueue({:ok, raffle}) do
    Logger.info("Enqueue Raffle Job #{raffle.id}")

    %{id: raffle.id}
    |> RaffleJob.new(unique: [period: 300], scheduled_at: raffle.date)
    |> Oban.insert()
  end
end
