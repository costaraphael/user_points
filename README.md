# UserPoints

A simple Phoenix application with the sole purpose of returning 2 (sometimes less) random users.

## Running the application

To start the server you will need to have PostgreSQL running somehow. See [here](#setting-up-the-database) for instructions on how to get that set up.

With the database working, you can run the application with the following:

- `mix deps.get` to fetch the application dependencies
- `mix ecto.setup` to set up the application database schema and run any seeds
- `mix phx.server` to start the application server

Now the application should be available at [`localhost:4000`](http://localhost:4000):

```bash
$ curl http://localhost:4000
{"timestamp":null,"users":[{"id":36,"points":99},{"id":24,"points":98}]}
```

## Running tests

After the database server is properly set up (look [here](#setting-up-the-database) for further instructions), you can run the application's test suite by using the following commands:

- `mix deps.get` to fetch the application dependencies
- `mix test` to run the test suite

As an additional bonus, you can also use the `mix tmwtd` task (*Tell Me What To Do*). It will run the tests after every file change, in order, and stop at the first failure.

This makes it easier to write your specification first in the form of tests, and then focusing only in implementing it one bit at a time. TDD FTW!

## Setting up the database

Here are some instructions on how to properly set up PostgreSQL for this application. One of the following should work for you:

### Using `docker-compose`

This project already comes with a `docker-compose.yml` file that sets up a database for you. To use it, just make sure you have `docker` and `docker-compose` installed and working, and then run `docker-compose up -d` at the root of this repository.

Everything else should just work from now on.

### Setting up PostgreSQL manually

Head over to https://www.postgresql.org/download/ for the installation instruction for your operating system.

After the database is installed, update the `config/dev.exs` and `config/test.exs` files to change the database connection port to your newly installed PostgreSQL instance.
