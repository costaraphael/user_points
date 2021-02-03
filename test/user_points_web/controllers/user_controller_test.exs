defmodule UserPointsWeb.UserControllerTest do
  use UserPointsWeb.ConnCase

  alias UserPoints.Users

  setup %{conn: conn} do
    %{conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup %{conn: conn} do
      %{route: Routes.user_path(conn, :index)}
    end

    test "lists the users alongside the previous timestamp", %{conn: conn, route: route} do
      Users.shuffle_user_points()

      current_timestamp = DateTime.utc_now() |> DateTime.truncate(:second)

      assert %{"users" => users, "timestamp" => nil} =
               conn
               |> get(route)
               |> json_response(200)

      assert is_list(users)
      assert length(users) <= 2
      assert Enum.all?(users, &(Map.keys(&1) == ~w[id points]))
      assert Enum.all?(users, &is_number(&1["id"]))
      assert Enum.all?(users, &is_number(&1["points"]))

      assert %{"users" => ^users, "timestamp" => response_timestamp} =
               conn
               |> get(route)
               |> json_response(200)

      assert {:ok, response_timestamp, 0} = DateTime.from_iso8601(response_timestamp)

      assert DateTime.truncate(response_timestamp, :second) == current_timestamp
    end
  end
end
