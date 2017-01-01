defmodule Kai.RequirementsTest do
  use ExUnit.Case
  import Kai.Factory
  alias Kai.Requirements

  for line <- File.stream!(Path.join([__DIR__, "test-data.txt"]), [], :line) do
    [name, attrs, expected] = 
      line |> String.split("||") |> Enum.map(&String.strip(&1))

    test "it computes nutrient requirements for: " <> name do      
      {expected, []} = Code.eval_string(unquote(expected))
      {attrs, []} = Code.eval_string(unquote(attrs))
      nutrients = build(:user, attrs) |> Requirements.nutrients

      assert ^expected = nutrients
    end
  end

end
