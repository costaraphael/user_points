now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

users =
  for _ <- 1..100 do
    %{
      points: 0,
      inserted_at: now,
      updated_at: now
    }
  end

UserPoints.Repo.insert_all(UserPoints.Users.User, users)
