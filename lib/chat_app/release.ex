defmodule ChatApp.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :chat_app

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  alias ChatApp.Account
  def seed_data() do
    load_app()

    %{
      "username" => "hari",
      "password" => "pass"
    }
    |> Account.create_user()

    %{
      "username" => "esther",
      "password" => "pass"
    }
    |> Account.create_user()

    %{
      "username" => "nandhini",
      "password" => "pass"
    }
    |> Account.create_user()

    %{
      "username" => "nobody",
      "password" => "pass"
    }
    |> Account.create_user()
      end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
