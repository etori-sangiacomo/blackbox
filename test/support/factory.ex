defmodule Blackbox.Factory do
  use ExMachina.Ecto, repo: Blackbox.Repo

  use Blackbox.UserFactory
end
