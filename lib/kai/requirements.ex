
defmodule Kai.Requirements do
  alias Kai.{Endpoint, Router, User}
  
  defstruct [:age, :height, :weight, :sex]
  
  @female -161
  @male 5
  @mean -76

  def calories(:sex, :age, :height, :weight, :activity) do 
  end

  # https://en.wikipedia.org/wiki/Harris%E2%80%93Benedict_equation
  def baseline_metabolic_rate(age, height, weight) do
    (10 * weight) + (6.25 * height) - (5 * age)  
  end


end
