defmodule UserPoints.UsersHelpers do
  @moduledoc """
  Functions to help test features related to the `UserPoints.Users` context.
  """

  import ExUnit.Assertions

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

  @doc """
  Takes the lists of users before and after an operation to ensure the users were properly
  randomized.
  """
  def assert_users_were_randomized(users_before, users_after) do
    assert length(users_before) == length(users_after)

    unchanged_users =
      [users_before, users_after]
      |> Enum.zip()
      |> Enum.reject(fn {user_before, user_after} ->
        assert user_before.id == user_after.id

        user_before.points != user_after.points
      end)
      |> Enum.count()

    # some users might end up with the same points, but more than 10% of them indicates that
    # something is probably off
    assert unchanged_users / length(users_before) < 0.1

    # some users might end up with the same points as other users, but we still expect some degree
    # of diversity in the end result
    assert users_after |> Enum.uniq_by(& &1.points) |> length() > 40
  end
end
