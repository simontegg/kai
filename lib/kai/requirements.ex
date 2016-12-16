
defmodule Kai.Requirements do
  alias Kai.User 

  def nutrients(params) do 
    %{
      calories: calories(params),
      biotin_ai: biotin_ai(params),
      folate_dfe_rda: folate_dfe_rda(params),
      niacin_ne_rda: niacin_ne_rda(params)
    }
  end

  def calories(params) do
    multipier = activity_multiplier(params.activity)

    params 
    |> baseline_metabolic_rate 
    |> Kernel.*(multipier)
    |> round
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

    # http://lpi.oregonstate.edu/mic/vitamins/biotin
    def biotin_ai(%{:age => age}) do
      cond do
        age > 0 and age < 4   -> 0.008
        age > 3 and age < 9   -> 0.012
        age > 8 and age < 14  -> 0.02
        age > 13 and age < 19 -> 0.025
        age > 18              -> 0.03
      end
    end

    def folate_dfe_rda(%{:age => age}) do
      cond do
        age > 0 and age < 4   -> 0.150
        age > 3 and age < 9   -> 0.200
        age > 8 and age < 14  -> 0.300
        age > 13              -> 0.400
      end
    end

    def niacin_ne_rda(%{:age => age, :sex => sex}) do
      cond do
        age > 0 and age < 4   -> 6
        age > 3 and age < 9   -> 8
        age > 8 and age < 14  -> 9
        age > 13              -> if age == "female", do: 14, else: 16
      end
    end

end
