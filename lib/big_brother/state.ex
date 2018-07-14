defmodule BigBrother.State do
  use Agent

  def start_link do
    data = BigBrother.Init.fetch_all
    Agent.start_link(fn -> data end, name: __MODULE__)
  end

  def get_version(repo, branch) do
    Agent.get(__MODULE__, &get_in(&1, [repo, branch, :version]))
  end

  def set_version(repo, branch, version) do
    Agent.update(__MODULE__, &put_in(&1, [repo, branch, :version], version))
  end
end
