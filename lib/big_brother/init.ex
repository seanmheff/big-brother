defmodule BigBrother.Init do
  use Agent 

  # Agent Callbacks
  def start_link do
    Agent.start_link(fn() -> fetch_all_versions() end, name: __MODULE__)
  end

  # Our functions
  def read_config do
    with {:ok, body} <- File.read("./github.json"),
         {:ok, json} <- Poison.decode(body), do: json
  end

  def fetch_update(repo, branch) do
    version = BigBrother.GitHub.fetch_version(repo, branch)
    set_version(repo, branch, version)
    BigBrotherWeb.VersionChannel.emit(repo, branch, version)
  end

  def fetch_all_versions do
    read_config()
    |> Enum.map(fn {repo, branches} -> {
      repo, Enum.map(branches, fn(branch) ->
        { branch, %{ version: BigBrother.GitHub.fetch_version(repo, branch) } }
      end)
      |> Enum.into(%{})
    } end)
    |> Enum.into(%{})
  end

  # Helpers
  def get_all_versions do
    Agent.get(__MODULE__, fn(data) -> data end)
  end

  def get_version(repo, branch) do
    Agent.get(__MODULE__, &get_in(&1, [repo, branch, :version]))
  end

  def set_version(repo, branch, version) do
    Agent.update(__MODULE__, &put_in(&1, [repo, branch, :version], version))
  end

  def is_monitored_branch?(repo, branch) do
    case Agent.get(__MODULE__, &get_in(&1, [repo, branch])) do
      nil -> false
      _ -> true
    end
  end
end
