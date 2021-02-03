defmodule UserPoints.Users.User do
  @moduledoc """
  A user in the application.
  """

  use Ecto.Schema

  schema "users" do
    field :points, :integer

    timestamps()
  end
end
