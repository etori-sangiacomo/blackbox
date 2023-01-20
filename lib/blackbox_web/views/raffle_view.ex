defmodule BlackboxWeb.RaffleView do
  use BlackboxWeb, :view
  alias BlackboxWeb.RaffleView

  def render("show.json", %{raffle: raffle}) do
    %{data: render_one(raffle, RaffleView, "raffle.json")}
  end

  def render("show.json", %{winner: raffle}) do
    %{data: render_one(raffle, RaffleView, "raffle_result.json")}
  end

  def render("raffle.json", %{raffle: raffle}) do
    %{id: raffle.id}
  end

  def render("raffle_result.json", %{raffle: raffle}) do
    case raffle.winner == nil do
      true ->
        %{data: "Raffle processed but there was no user subscribe"}

      false ->
        %{
          id: raffle.winner.id,
          name: raffle.winner.name,
          email: raffle.winner.email
        }
    end
  end
end
