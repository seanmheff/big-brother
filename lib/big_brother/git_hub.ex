defmodule BigBrother.GitHub do
  def fetch_version(repo, branch) do
    IO.puts "GitHub.fetch_version(#{repo}, #{branch})"

    url = "https://api.github.com/repos/Jibestream/#{repo}/contents/build_tracker"
    %HTTPotion.Response{ status_code: status_code, body: body } = fetch(url, branch)

    case status_code do
      200 -> decode_api_response(body)
      _ -> "Unknown version"
    end
  end

  def fetch_dependencies(repo, branch) do
    IO.puts "GitHub.fetch_dependencies(#{repo}, #{branch})"

    url = "https://api.github.com/repos/Jibestream/#{repo}/contents/package.json"
    %HTTPotion.Response{ status_code: status_code, body: body } = fetch(url, branch)

    case status_code do
      200 -> body
      |> decode_api_response
      |> Poison.decode!
      |> Map.take(["version", "dependencies", "devDependencies"])
      _ -> %{}
    end
  end

  def fetch(url, branch) do
    http_potion_config = [
      basic_auth: { System.get_env("API_USER"), System.get_env("API_PASS") },
      headers: %{ "User-Agent": "Big-Brother" },
      query: %{ ref: branch }
    ]
    HTTPotion.get(url, http_potion_config)
  end

  def decode_api_response(http_response) do
    # Read about API response https://developer.github.com/v3/repos/contents/#get-contents
    http_response
    |> Poison.decode! # convert JSON to Elixir Map
    |> Map.get("content") # get the response "Content"
    |> Base.decode64!(ignore: :whitespace) # decode the file contents
  end
end
