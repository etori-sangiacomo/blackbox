defmodule Blackbox.Domain.LotteryTest do
  use Blackbox.DataCase

  alias Blackbox.Domain.Lottery
  alias Lottery.Schemas.{Raffle, UserRaffle}

  import Blackbox.Factory

  describe "raffles" do
    @invalid_attrs %{date: nil, name: nil}

    test "get_raffle/1 returns the raffle with given id" do
      raffle = insert(:raffle)
      assert {:ok, %Raffle{}} = Lottery.get_raffle(raffle.id)
    end

    test "get_winner/1 returns the raffle with given id" do
      user = insert(:user)
      raffle = insert(:raffle, winner_id: user.id, status: "processed")

      assert {:ok, %Raffle{} = raffle} = Lottery.get_winner(raffle.id)
      assert raffle.winner_id == user.id
      assert raffle.status == :processed
    end

    test "get_winner/1 raffle has not processed returns error" do
      raffle = insert(:raffle)

      assert {:error, :raffle_has_not_processed} = Lottery.get_winner(raffle.id)
    end

    test "get_winner/1 with invalid raffle returns error changeset" do
      assert {:error, :not_found} = Lottery.get_winner(Ecto.UUID.generate())
    end

    test "create_raffle/1 with valid data creates a raffle" do
      valid_attrs = %{name: "some name", date: ~U[2023-01-16 20:45:49Z]}

      assert {:ok, %Raffle{} = raffle} = Lottery.create_raffle(valid_attrs)
      assert raffle.name == "some name"
      assert raffle.date == ~U[2023-01-16 20:45:49Z]
      assert raffle.status == :created
      assert raffle.winner_id == nil
    end

    test "create_raffle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lottery.create_raffle(@invalid_attrs)
    end

    test "update_raffle/2 with valid data updates the raffle" do
      raffle = insert(:raffle)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Raffle{} = raffle} = Lottery.update_raffle(raffle, update_attrs)
      assert raffle.name == "some updated name"
    end

    test "update_raffle/2 with invalid data returns error changeset" do
      raffle = insert(:raffle)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  name: {"can't be blank", [validation: :required]},
                  date: {"can't be blank", [validation: :required]}
                ]
              }} = Lottery.update_raffle(raffle, @invalid_attrs)
    end

    test "subscriber/1 with valid data subscribes an user to raffle" do
      user = insert(:user)
      raffle = insert(:raffle)

      assert {:ok, %UserRaffle{} = subscribe} =
               Lottery.subscribe(%{user_id: user.id, raffle_id: raffle.id})

      assert subscribe.user_id == user.id
      assert subscribe.raffle_id == raffle.id
    end

    test "list_users_raffle/1 with valid data returns list of user_ids" do
      user_x = insert(:user)
      user_y = insert(:user)
      raffle = insert(:raffle)

      Lottery.subscribe(%{user_id: user_x.id, raffle_id: raffle.id})
      Lottery.subscribe(%{user_id: user_y.id, raffle_id: raffle.id})

      assert [_user_x | _user_y] = Lottery.list_users_raffle(raffle.id)
    end
  end
end
