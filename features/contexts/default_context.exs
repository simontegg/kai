defmodule WhiteBread.DefaultContext do
  use WhiteBread.Context 
  use Hound.Helpers
  
  @port to_string(Application.get_env(:kai, Kai.Endpoint)[:http][:port])
  @base_url "http://localhost:"
  
  scenario_starting_state fn state ->
    Application.ensure_all_started(:hound)
    Hound.start_session

    url = @base_url <> @port
    %{url: url}
  end

  scenario_finalize fn state ->
    Hound.end_session
  end
  
  given_ ~r/^I navigate to "(?<path>[^"]+)"$/, fn state, %{path: path} ->
    IO.inspect state
    href = state.url  <> path
    navigate_to(href)
    {:ok, state}
  end

  then_ ~r/^the page contains the header "(?<header>[^"]+)"$/, fn state, %{header: header} ->
    actual_header = find_element(:tag, "h3") |> visible_text

    assert actual_header == header
    {:ok, state}
  end

  then_ ~r/^the page contains the legend "(?<legend>[^"]+)"$/, fn state, %{legend: legend} ->
    actual_legends = find_all_elements(:tag, "legend")
                    |> Enum.map(fn el -> visible_text(el) end)

    assert Enum.member?(actual_legends, legend)
    {:ok, state}
  end

end
