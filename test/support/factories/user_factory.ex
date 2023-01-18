defmodule Blackbox.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Blackbox.Domain.Accounts.Schemas.User{
          name: sequence(:name, fn n -> "João #{n}" end),
          email: sequence(:email, &"joao#{&1}@mail.com")
        }
      end
    end
  end
end
