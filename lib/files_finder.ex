defmodule ExcellentMigrations.FilesFinder do
  @moduledoc false

  def get_migrations_paths do
    start_after = Application.get_env(:excellent_migrations, :start_after)

    "**/migrations/*.exs"
    |> Path.wildcard()
    |> Enum.filter(&relevant_file?(&1, start_after))
  end

  def relevant_file?(path, start_after) do
    migration_prefix = Application.get_env(:excellent_migrations, :migration_path, "priv/migrations")

    !String.starts_with?(path, ["deps/", "_build/"]) &&
      !String.contains?(path, ["/deps/", "/_build/"]) &&
      String.starts_with?(path, migration_prefix) &&
      migration_timestamp(path) > start_after
  end

  defp migration_timestamp(path) do
    path
    |> Path.basename()
    |> String.split("_")
    |> hd()
  end
end
