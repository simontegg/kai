defmodule Kai.Features.ComputeTest do

  # use Cabbage.Feature, async: true, file: "compute-groceries.feature"
  # 
  # use Hound.Helpers
  # 
  # setup do
  #   on_exit fn ->
  #     Hound.end_session
  #   end

  #   Application.ensure_all_started(:hound)
  #   Hound.start_session

  #   {:ok, %{path: "/", title: ""}}
  # end

  # defgiven ~r/^I am not logged in/, state, _ do 
  #   IO.inspect "not logged in"
  #   %{test: true}
  # end


  # defwhen ~r/^I navigate to (?<path>[^"]+)/, state, %{path: path} do
  #   navigate_to(path)
  # end

  # defthen ~r/I see the "(?<title>[^"]+)" page/, state, %{title: title} do
  #   assert title == page_title() 
  # end


  # # defthen ~r/^I should see the "(?<title>[^"]+)" page$/, state, %{title: title} do
  #   assert title == page_title()
  # end

  # defthen ~r/^the page contains the header "(?<header>[^"]+)"$/, state, %{header: header} do
  #   actual_header = find_element(:tag, "h3") |> visible_text

  #   assert actual_header == header
  # end

  # defthen ~r/^the page contains the legend "(?<legend>[^"]+)"$/, state, %{legend: legend} do
  #   :tag    
  #   |> find_all_elements("legend") 
  #   |> Enum.map(fn el -> visible_text(el) end)
  #   |> Enum.member?(legend)
  #   |> assert

  # end

  # defthen ~r/^the page contains the text "(?<text>[^"]+)"$/, state, %{text: text} do
  #   element = find_element(:xpath, "//*[text()[normalize-space(.)='#{text}']]")

  #   assert element
  # end
end
