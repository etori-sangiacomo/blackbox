defmodule BlackboxWeb.Router do
  use BlackboxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BlackboxWeb do
    pipe_through :api
  end
end
