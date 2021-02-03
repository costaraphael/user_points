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
      assert_users_were_randomized(pre_update, post_update)
    end
  end
end
