defmodule Blackbox.Domain.AccountsTest do
  use Blackbox.DataCase

  alias Blackbox.Domain.Accounts
  alias Accounts.Schemas.User

  import Blackbox.Factory

  describe "users" do
    @invalid_attrs %{email: nil, name: nil}

    test "get_user/1 returns the user with given id" do
      user = insert(:user)
      assert {:ok, %User{}} = Accounts.get_user(user.id)
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some_email@test.com", name: "some name"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "some_email@test.com"
      assert user.name == "Some Name"
    end

    test "create_user/1 with email has already been taken returns error changeset" do
      valid_attrs = %{email: "some_email@test.com", name: "some name"}

      assert {:ok, %User{}} = Accounts.create_user(valid_attrs)

      invalid_email = %{email: "some_email@test.com", name: "some name"}

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  email:
                    {"has already been taken",
                     [constraint: :unique, constraint_name: "users_email_index"]}
                ]
              }} = Accounts.create_user(invalid_email)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error,
              %Ecto.Changeset{
                errors: [
                  email: {"can't be blank", [validation: :required]},
                  name: {"can't be blank", [validation: :required]}
                ]
              }} = Accounts.create_user(@invalid_attrs)
    end
  end
end
