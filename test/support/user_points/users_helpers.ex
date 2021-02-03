defmodule UserPoints.UsersHelpers do
  @moduledoc """
  Functions to help test features related to the `UserPoints.Users` context.
  """

  alias UserPoints.Repo
  alias UserPoints.Users.User

  @doc """
  Lists all users in the database.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Creates a user with the given params.
  """
  def create_user(params) do
    User
    |> struct!(params)
    |> Repo.insert!()
  end
end
