defmodule Blackbox.UsersRafflesFactory do
  defmacro __using__(_opts) do
    quote do
      def users_raffles_factory do
        %Blackbox.Domain.Lottery.Schemas.UserRaffle{
          user: build(:user),
          raffle: build(:raffle)
        }
      end
    end
  end
end
