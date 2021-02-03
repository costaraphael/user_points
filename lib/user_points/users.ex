defmodule UserPoints.Users do
  @moduledoc """
  The users context.
  """

  import Ecto.Query

  alias UserPoints.Repo
  alias UserPoints.Users.User

  @type list_top_users_option() :: {:min_points, non_neg_integer()} | {:limit, non_neg_integer()}

  @doc """
  Lists the users with the highest amount of points.

  The users are always ordered by amount of points in descending order.

  Accepts the options:

    - `:min_points` - filters the users that have this amount of points or less (required).
    - `:limit` - limits how many users should be returned (optional).
  """
  @spec list_top_users([list_top_users_option()]) :: [User.t()]
  def list_top_users(options) do
    min_points = Keyword.fetch!(options, :min_points)

    User
    |> where([u], u.points > ^min_points)
    |> order_by(desc: :points)
    |> maybe_limit(options[:limit])
    |> Repo.all()
  end

  @doc """
  Updates all the points for all users.
  """
  @spec shuffle_user_points :: :ok
  def shuffle_user_points do
    {_, nil} =
      User
      |> update(set: [points: fragment("RANDOM() * 100")])
      |> Repo.update_all([])

    :ok
  end

  defp maybe_limit(query, nil), do: query
  defp maybe_limit(query, limit), do: limit(query, ^limit)
end
