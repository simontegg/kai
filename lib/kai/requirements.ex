
defmodule Kai.Requirements do
  alias Kai.{Endpoint, Router, User}
  @male 5
  @female -161

  def calories(sex, height, weight, activity) do 
    
  end

  # https://en.wikipedia.org/wiki/Harris%E2%80%93Benedict_equation
  def baseline_metabolic_rate(age, height, weight) do
    (10 * weight) + (6.25 * height) - (5 * age)  
  end


end
