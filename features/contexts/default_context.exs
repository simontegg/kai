defmodule WhiteBread.DefaultContext do
  use WhiteBread.Context 
  use Hound.Helpers
  
  @port Application.get_env(:kai, Kai.Endpoint)[:http][:port] |> to_string
  @base_url "http://localhost:" <> @port
  
  scenario_starting_state fn state ->
    Application.ensure_all_started(:hound)
    Hound.start_session

    %{key: "value"}
  end

  scenario_finalize fn state ->
    Hound.end_session
  end
  
  given_ ~r/^I navigate to "(?<path>[^"]+)"$/, fn state, %{path: path} ->
    @base_url |> Kernel.<>(path) |> navigate_to
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
