defmodule Blackbox.Domain.Lottery.Jobs.RaffleJob do
  @moduledoc """
  Run raffle job
  """

  use Oban.Worker, queue: :default, max_attempts: 3

  alias Blackbox.Domain.Lottery.Services.RaffleProcessService
  alias BlackboxWeb.Actions.RaffleShowAction

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id}}) do
    Logger.info("Running Raffle Job: " <> id)

    RaffleProcessService.call(%RaffleShowAction{id: id})

    :ok
  end
end
