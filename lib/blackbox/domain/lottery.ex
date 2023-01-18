defmodule Blackbox.Domain.Lottery do
  @moduledoc """
  The Raffles context.
  """

  import Ecto.Query, warn: false
  alias Blackbox.Repo

  alias Blackbox.Domain.Lottery.Schemas.Raffle

  @doc """
  Gets a single raffle.

  Raises `Ecto.NoResultsError` if the Raffle does not exist.

  ## Examples

      iex> get_raffle(123)
      {:ok, %Raffle{}}

      iex> get_raffle(456)
      {:error, :not_found}

  """
  def get_raffle(id) do
    case Repo.get(Raffle, id) do
      nil -> {:error, :not_found}
      raffle -> {:ok, raffle}
    end
  end

  @doc """
  Gets an winner from raffle.

  ## Examples

      iex> get_winner(123)
      %Raffle{}

      iex> get_winner(456)
      nil

  """
  def get_winner(id) do
    Raffle
    |> Repo.get(id)
    |> case do
      nil ->
        {:error, :not_found}

      %{status: :created} ->
        {:error, :raffle_has_not_processed}

      raffle ->
        {:ok, raffle |> Repo.preload(:winner)}
    end
  end

  @doc """
  Creates a raffle.

  ## Examples

      iex> create_raffle(%{field: value})
      {:ok, %Raffle{}}

      iex> create_raffle(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_raffle(attrs \\ %{}) do
    %Raffle{}
    |> Raffle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Update a raffle.

  ## Examples

      iex> update_raffle(raffle, %{field: new_value})
      {:ok, %Raffle{}}

      iex> update_raffle(raffle, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_raffle(%Raffle{} = raffle, attrs) do
    raffle
    |> Raffle.changeset(attrs)
    |> Repo.update()
  end

  alias Blackbox.Domain.Lottery.Schemas.UserRaffle

  @doc """
  Create a relation between user and raffle.

  ## Examples

      iex> subscribe(%{field: value})
      {:ok, %UserRaffle{}}

      iex> subscribe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def subscribe(attrs \\ %{}) do
    %UserRaffle{}
    |> UserRaffle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets all users registered in raffle.

  ## Examples

      iex> list_users_raffle(123)
      %UserRaffle{}

      iex> list_users_raffle(456)
      []

  """
  def list_users_raffle(id) do
    UserRaffle
    |> where([ur], ur.raffle_id == ^id)
    |> select([ur], ur.user_id)
    |> Repo.all()
  end
end
