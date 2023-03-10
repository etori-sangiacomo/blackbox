defmodule BlackboxWeb.Router do
  use BlackboxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BlackboxWeb do
    pipe_through :api
    resources "/users", UserController, only: [:create]
    resources "/raffles", RaffleController, only: [:create, :show]
  end
end
