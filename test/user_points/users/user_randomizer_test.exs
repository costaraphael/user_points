defmodule UserPoints.Users.UserRandomizerTest do
  use UserPoints.DataCase, async: true

  import UserPoints.UsersHelpers

  alias UserPoints.Users
  alias UserPoints.Users.UserRandomizer

  test "randomizes the users points on every interval tick" do
    pre_update = list_users() |> Enum.sort_by(& &1.id)

    pid = start_supervised!({UserRandomizer, interval: 50, name: nil})
    Ecto.Adapters.SQL.Sandbox.allow(UserPoints.Repo, self(), pid, :shared)

    Process.sleep(40)

    assert pre_update == list_users() |> Enum.sort_by(& &1.id)

    Process.sleep(20)

    post_update = list_users() |> Enum.sort_by(& &1.id)
    assert_users_were_randomized(pre_update, post_update)
  end

  test "allows for fetching the top two users based on the max_number in state" do
    pid = start_supervised!({UserRandomizer, name: nil})
    Ecto.Adapters.SQL.Sandbox.allow(UserPoints.Repo, self(), pid, :shared)
    server_state = :sys.get_state(pid)

    assert %{users: users} = UserRandomizer.get_top_two_users(pid)

    assert users == Users.list_top_users(min_points: server_state.min_points, limit: 2)
  end

  test "stores the timestamp of every call to it, returning it in the next call" do
    pid = start_supervised!({UserRandomizer, name: nil})
    Ecto.Adapters.SQL.Sandbox.allow(UserPoints.Repo, self(), pid, :shared)

    assert %{timestamp: nil} = UserRandomizer.get_top_two_users(pid)
    query_time = DateTime.utc_now()

    Process.sleep(100)

    assert %{timestamp: timestamp} = UserRandomizer.get_top_two_users(pid)

    assert DateTime.truncate(query_time, :millisecond) ==
             DateTime.truncate(timestamp, :millisecond)
  end
end
