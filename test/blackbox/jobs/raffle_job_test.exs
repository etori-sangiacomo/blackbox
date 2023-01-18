defmodule Blackbox.Jobs.RaffleJobTest do
  @moduledoc false

  use Blackbox.DataCase
  use Oban.Testing, repo: Blackbox.Repo

  import Blackbox.Factory

  alias Blackbox.Domain.Lottery.Jobs.RaffleJob

  describe "perform/1" do
    test "should enqueue raffleJob" do
      raffle = insert(:raffle)

      assert :ok = perform_job(RaffleJob, %{"id" => raffle.id})
    end
  end
end
