
defmodule Kai.Requirements do
  alias Kai.{Endpoint, Router, User}
  
  defstruct [:age, :height, :weight, :sex]
  
  @female -161
  @male 5
  @mean -76

  def daily_kilo_calories(params) do 
    baseline_metabolic_rate(params) * activity_multiplier(params.activity)
  end

  def activity_multiplier(activity) do
    case activity do
      0         -> 1.2
      {1, 2}    -> 1.375
      {3, 4, 5} -> 1.55
      {6, 7}    -> 1.725
      _         -> 1.9
    end
  end

  # https://en.wikipedia.org/wiki/Harris%E2%80%93Benedict_equation
  def baseline_metabolic_rate(%{
    :sex => sex, 
    :height => height, 
    :weight => weight, 
    :age => age
  }) when sex == "female", do: (
    (10 * weight) + (6.25 * height) - (5 * age) + @female
  )

  def baseline_metabolic_rate(%{
    :sex => sex, 
    :height => height, 
    :weight => weight, 
    :age => age
  }) when sex == "male", do: (
    (10 * weight) + (6.25 * height) - (5 * age) + @male
  )

  def baseline_metabolic_rate(params) do
    (10 * params.weight) + (6.25 * params.height) - (5 * params.age) + @mean
  end

end
