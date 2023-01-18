# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Blackbox.Repo.insert!(%Blackbox.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Blackbox.Repo
alias Blackbox.Domain.Accounts.Schemas.User
alias Blackbox.Domain.Lottery.Schemas.Raffle
alias Blackbox.Domain.Lottery.Schemas.UserRaffle

Enum.each(1..10, fn x ->
  user = Repo.insert!(%User{name: "user#{x}", email: "user#{x}@test.com.br"})

  raffle =
    Repo.insert!(%Raffle{
      name: "raffle#{x}",
      date: DateTime.utc_now() |> DateTime.truncate(:second)
    })

  Repo.insert!(%UserRaffle{user_id: user.id, raffle_id: raffle.id})
end)
