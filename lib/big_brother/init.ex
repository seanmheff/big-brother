defmodule BigBrother.Init do
  def read_config do
    with {:ok, body} <- File.read("./github.json"),
         {:ok, json} <- Poison.decode(body), do: json
  end

  def fetch_all do
    read_config()
    |> Enum.map(fn {repo, branches} -> {
      repo, Enum.map(branches, fn(branch) ->
        { branch, %{ version: BigBrother.GitHub.fetch_version(repo, branch) } }
      end)
      |> Enum.into(%{})
    } end)
    |> Enum.into(%{})
  end
end
