defmodule BlackboxWeb.UserControllerTest do
  use BlackboxWeb.ConnCase

  alias Blackbox.Domain.Accounts
  alias Blackbox.Domain.Accounts.Schemas.User

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Create/2" do
    test "Returns ok when valid data", %{conn: conn} do
      params = %{name: "test", email: "test@gmail.com"}

      conn = post(conn, "/api/users", user: params)

      assert %{"id" => id} = json_response(conn, 201)["data"]
      assert is_binary(id) == true

      {:ok, %User{} = user} = Accounts.get_user(id)
      assert user.name == String.capitalize(params.name)
      assert user.email == params.email
    end

    test "Returns error when invalid email request", %{conn: conn} do
      params = %{name: "Test", email: "email"}

      conn = post(conn, "/api/users", user: params)

      assert %{"errors" => ["Email has invalid format"]} = json_response(conn, 422)
    end

    test "Returns error when invalid all format data request", %{conn: conn} do
      params = %{name: "T", email: "email"}

      conn = post(conn, "/api/users", user: params)

      assert %{"errors" => [_error1, _error2]} = json_response(conn, 422)
    end
  end
end
