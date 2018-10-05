defmodule BigBrother.GitHub do
  alias HTTPotion.Response

  def fetch_version(repo, branch) do
    IO.puts "GitHub.fetch_version(#{repo}, #{branch})"
    %Response{ status_code: status, body: body } = fetch_file(repo, branch, "build_tracker")
    case status do
      200 -> decode_api_response(body)
      _ -> "Unknown version"
    end
  end

  def fetch_dependencies(repo, branch) do
    IO.puts "GitHub.fetch_dependencies(#{repo}, #{branch})"
    %Response{ status_code: status, body: body } = fetch_file(repo, branch, "package.json")
    case status do
      200 -> body
      |> decode_api_response
      |> Poison.decode!
      |> Map.take(["version", "dependencies", "devDependencies"])
      _ -> %{}
    end
  end

  def fetch_file(repo, branch, file) do
    url = "https://api.github.com/repos/Jibestream/#{repo}/contents/#{file}"
    HTTPotion.get(url, [
      basic_auth: { System.get_env("API_USER"), System.get_env("API_PASS") },
      headers: %{ "User-Agent": "Big-Brother" },
      query: %{ ref: branch }
    ])
  end

  def decode_api_response(http_response) do
    # Read about API response https://developer.github.com/v3/repos/contents/#get-contents
    http_response
    |> Poison.decode! # convert JSON to Elixir Map
    |> Map.get("content") # get the response "Content"
    |> Base.decode64!(ignore: :whitespace) # decode the file contents
  end
end
