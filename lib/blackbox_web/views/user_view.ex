defmodule BlackboxWeb.UserView do
  use BlackboxWeb, :view
  alias BlackboxWeb.UserView

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id}
  end
end
