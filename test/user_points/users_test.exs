defmodule UserPoints.UsersTest do
  use UserPoints.DataCase, async: true

  import UserPoints.UsersHelpers

  alias UserPoints.Users

  describe "list_top_users/1" do
    test "lists the users with a number of points that is higher than the argument" do
      create_user(points: 50)
      create_user(points: 51)
      create_user(points: 52)
      create_user(points: 53)

      users = Users.list_top_users(min_points: 50)

      assert [%{points: 53}, %{points: 52}, %{points: 51}] = users
    end

    test "allows limiting the amount of returned users" do
      create_user(points: 50)
      create_user(points: 51)
      create_user(points: 52)
      create_user(points: 53)

      users = Users.list_top_users(min_points: 50, limit: 2)

      assert [%{points: 53}, %{points: 52}] = users
    end
  end

  describe "shuffle_user_points/0" do
    test "randomly updates all the users' scores" do
      pre_update = list_users() |> Enum.sort_by(& &1.id)

      assert :ok = Users.shuffle_user_points()

      post_update = list_users() |> Enum.sort_by(& &1.id)

      assert length(pre_update) == length(post_update)

      unchanged_users =
        [pre_update, post_update]
        |> Enum.zip()
        |> Enum.reject(fn {pre_update_user, post_update_user} ->
          assert pre_update_user.id == post_update_user.id

          pre_update_user.points != post_update_user.points
        end)
        |> Enum.count()

      # some users might end up with the same points, but more than 10% of them indicates that
      # something is probably off
      assert unchanged_users / length(pre_update) < 0.1

      # some users might end up with the same points as other users, but we still expect some degree
      # of diversity in the end result
      assert post_update |> Enum.uniq_by(& &1.points) |> length() > 40
    end
  end
end
