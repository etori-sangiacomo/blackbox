defmodule Blackbox.RaffleFactory do
  defmacro __using__(_opts) do
    quote do
      def raffle_factory do
        %Blackbox.Domain.Lottery.Schemas.Raffle{
          name: sequence(:name, fn n -> "Raffle ##{n}" end),
          date: ~U[2050-01-16 23:38:08Z],
          status: "created",
          winner_id: nil
        }
      end
    end
  end
end
