
defmodule Kai.Requirements do

  def daily_kilo_calories(params) do 
    IO.inspect activity_multiplier(params.activity)
    IO.inspect baseline_metabolic_rate(params)
    baseline_metabolic_rate(params) * activity_multiplier(params.activity)
  end

  def activity_multiplier(activity) do
    IO.inspect activity
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
    :weight => weight,
    :height => height,
    :age => age,
    :sex => sex }) do 
    (10 * weight) + (6.25 * height) - (5 * age) + modifier(sex) 
  end

  def modifier(sex) do
    case sex do
      "female"  -> -161
      "male"    -> 5
      _         -> -76
    end
  end

end
