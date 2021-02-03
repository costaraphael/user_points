defmodule UserPointsWeb.UserController do
  use UserPointsWeb, :controller

  alias UserPoints.Users.UserRandomizer

  def index(conn, _params) do
    result = UserRandomizer.get_top_two_users()

    render(conn, "index.json", result)
  end
end
