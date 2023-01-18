defmodule BlackboxWeb.RaffleControllerTest do
  use BlackboxWeb.ConnCase

  alias Blackbox.Domain.Lottery
  alias Blackbox.Utils.Helpers

  import Blackbox.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create/2" do
    test "returns ok when valid data", %{conn: conn} do
      params = %{name: "Raffle name", date: 1_674_084_128}

      conn = post(conn, "/api/raffles", raffle: params)

      assert %{"id" => id} = json_response(conn, 201)["data"]
      assert is_binary(id) == true

      {:ok, raffle} = Lottery.get_raffle(id)
      assert raffle.name == params.name
      {:ok, params_date} = params.date |> Helpers.date_from_unix()
      assert raffle.date == params_date
    end

    test "returns error when invalid name", %{conn: conn} do
      params = %{name: "", date: 1_674_084_128}

      conn = post(conn, "/api/raffles", raffle: params)

      assert %{"errors" => ["Name can't be blank"]} = json_response(conn, 422)
    end

    test "returns error when invalid date", %{conn: conn} do
      params = %{name: "Test", date: "1b"}

      conn = post(conn, "/api/raffles", raffle: params)

      assert %{"errors" => ["Date is invalid"]} = json_response(conn, 422)
    end

    test "returns error when invalid all data request", %{conn: conn} do
      params = %{name: "", date: "1b"}

      conn = post(conn, "/api/raffles", raffle: params)

      assert %{"errors" => [_error1 | _error2]} = json_response(conn, 422)
    end

    test "returns error when date is expired", %{conn: conn} do
      params = %{name: "Rafe expired", date: 1_673_479_328}

      conn = post(conn, "/api/raffles", raffle: params)

      assert %{"errors" => ["Date expired"]} = json_response(conn, 422)
    end
  end

  describe "subscription/2" do
    test "returns ok when valid data", %{conn: conn} do
      user = insert(:user)

      raffle = insert(:raffle)
      params = %{user_id: user.id, raffle_id: raffle.id}

      conn = post(conn, "/api/raffles/", subscribe: params)

      assert json_response(conn, 201)
    end

    test "returns error when invalid user or raffle data", %{conn: conn} do
      user = insert(:user)
      params = %{user_id: user.id, raffle_id: 1}

      conn = post(conn, "/api/raffles/", subscribe: params)

      assert %{"errors" => ["Raffle_id is invalid"]} = json_response(conn, 422)

      raffle = insert(:raffle)
      params = %{user_id: 1, raffle_id: raffle.id}

      conn = post(conn, "/api/raffles/", subscribe: params)

      assert %{"errors" => ["User_id is invalid"]} = json_response(conn, 422)
    end

    test "returns error when raffle or user not found", %{conn: conn} do
      uuid = Ecto.UUID.generate()
      user = insert(:user)
      params = %{user_id: user.id, raffle_id: uuid}

      conn = post(conn, "/api/raffles/", subscribe: params)

      assert %{"errors" => ["Resource not found"]} = json_response(conn, 404)

      raffle = insert(:raffle)
      params = %{user_id: uuid, raffle_id: raffle.id}

      conn = post(conn, "/api/raffles/", subscribe: params)

      assert %{"errors" => ["Resource not found"]} = json_response(conn, 404)
    end

    test "returns error when raffle is processed", %{conn: conn} do
      user1 = insert(:user)
      user2 = insert(:user)

      raffle = insert(:raffle, %{status: "processed", winner_id: user1.id})

      params = %{user_id: user2.id, raffle_id: raffle.id}

      conn = post(conn, "/api/raffles/", subscribe: params)

      assert %{"errors" => ["Raffle has already processed"]} = json_response(conn, 406)
    end
  end

  describe "show/2 winner" do
    test "returns ok when valid data", %{conn: conn} do
      user = insert(:user)
      raffle = insert(:raffle, %{winner_id: user.id, status: "processed"})
      insert(:users_raffles, %{user: user, raffle: raffle})
      user_not_subscribed = insert(:user)

      conn = get(conn, "/api/raffles/#{raffle.id}")

      assert subject = json_response(conn, 200)["data"]
      assert subject["id"] == user.id
      assert subject["name"] == user.name
      assert subject["email"] == user.email
      refute subject["id"] == user_not_subscribed.id
    end

    test "returns error when raffle has not processed yet", %{conn: conn} do
      raffle = insert(:raffle)

      conn = get(conn, "/api/raffles/#{raffle.id}")

      assert %{"errors" => ["Raffle hasn't processed yet"]} = json_response(conn, 406)
    end

    test "returns error when invalid format data", %{conn: conn} do
      conn = get(conn, "/api/raffles/0")

      assert %{"errors" => ["Id is invalid"]} = json_response(conn, 422)
    end

    test "returns error when raffle not found", %{conn: conn} do
      uuid = Ecto.UUID.generate()
      conn = get(conn, "/api/raffles/#{uuid}")

      assert %{"errors" => ["Resource not found"]} = json_response(conn, 404)
    end
  end
end
