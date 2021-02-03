defmodule UserPoints.Users.UserRandomizer do
  @moduledoc """
  A `GenServer` that randomizes the user's points at every interval tick.

  It also allows fetching the top two users with a score higher than an internal random value.

  Usage:

      children = [
        {UserPoints.Users.UserRandomizer, interval: :timer.seconds(30), name: :my_randomized}
      ]

  Accepted options:

    - `:interval` - the amount of time, in milliseconds, in which users will be shuffled and a new
      minimum score will be set (default: `60_000`).
    - `:name` - the name in which to register the process (default: `#{inspect(__MODULE__)}`).
  """

  use GenServer

  alias UserPoints.Users

  @default_interval :timer.minutes(1)
  @default_name __MODULE__

  @type start_link_option :: {:interval, non_neg_integer()} | {:name, nil | GenServer.name()}

  @type get_top_two_users_result() :: %{users: [Users.User.t()], timestamp: nil | DateTime.t()}

  @doc """
  Starts the process and link it to the calling process.

  See the module documentation for available options.
  """
  @spec start_link([start_link_option()]) :: GenServer.on_start()
  def start_link(args) do
    {name, args} = Keyword.pop(args, :name, @default_name)

    start_opts =
      if name,
        do: [name: name],
        else: []

    GenServer.start_link(__MODULE__, args, start_opts)
  end

  @doc """
  Returns the top two users with a score higher than the internal random value.
  """
  @spec get_top_two_users() :: get_top_two_users_result()
  @spec get_top_two_users(server :: GenServer.server()) :: get_top_two_users_result()
  def get_top_two_users(server \\ @default_name) do
    GenServer.call(server, :get_top_two_users)
  end

  @impl true
  def init(args) do
    interval = Keyword.get(args, :interval, @default_interval)

    :timer.send_interval(interval, :shuffle)

    {:ok, %{min_points: get_min_points(), last_query: nil}}
  end

  @impl true
  def handle_call(:get_top_two_users, _from, state) do
    users = Users.list_top_users(min_points: state.min_points, limit: 2)
    new_state = %{state | last_query: DateTime.utc_now()}

    {:reply, %{users: users, timestamp: state.last_query}, new_state}
  end

  @impl true
  def handle_info(:shuffle, state) do
    :ok = Users.shuffle_user_points()

    {:noreply, %{state | min_points: get_min_points()}}
  end

  defp get_min_points do
    :random.uniform(100)
  end
end
