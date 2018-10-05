defmodule BigBrother.GitHub do
  def fetch_version(repo, branch) do
    case fetch_file(repo, branch, "build_tracker") do
      {:ok, file} -> file
      _ -> "Unknown version"
    end
  end

  def fetch_dependencies(repo, branch) do
    case fetch_file(repo, branch, "package.json") do
      {:ok, file} -> file
      |> Poison.decode!
      |> Map.take(["version", "dependencies", "devDependencies"])
      _ -> %{}
    end
  end

  def fetch_file(repo, branch, file) do
    url = "https://api.github.com/repos/Jibestream/#{repo}/contents/#{file}"
    %HTTPotion.Response{ status_code: status, body: body } = HTTPotion.get(url, [
      basic_auth: { System.get_env("API_USER"), System.get_env("API_PASS") },
      headers: %{ "User-Agent": "Big-Brother" },
      query: %{ ref: branch }
    ])
    case status do
      200 -> {:ok, decode_api_response(body)}
      _ -> {:error}
    end
  end

  defp decode_api_response(http_response) do
    # Read about API response https://developer.github.com/v3/repos/contents/#get-contents
    http_response
    |> Poison.decode! # convert JSON to Elixir Map
    |> Map.get("content") # get the response "Content"
    |> Base.decode64!(ignore: :whitespace) # decode the file contents
  end
end
