
defmodule Kai.Requirements do
  alias Kai.User 

  # daily
  def nutrients(params, days \\ 1) do 
    %{
      #macronutrients
      calories:            days * calories(params),
      protein:             days * protein_rdi(params),

      #vitamins
      biotin:              days * biotin_ai(params),
      folate_dfe:          days * folate_dfe_rda(params),
      niacin_ne:           days * niacin_ne_rda(params),
      pantothenic_acid:    days * pantothenic_acid_ai(params),
      riboflavin:          days * riboflavin_rda(params),
      thiamin:             days * thiamin_rda(params),
      vitamin_a_rae:       days * vitamin_a_rae_rda(params),
      vitamin_b6:          days * vitamin_b6_rda(params),
      vitamin_b12:         days * vitamin_b12_rda(params),
      vitamin_c:           days * vitamin_c_rda(params),
      vit_e_a_tocopherol:  days * vit_e_a_tocopherol_rda(params),
      vitamin_k1:          days * vitamin_k1_ai(params),

      #minerals
      calcium:             days * calcium_rda(params),
      chromium:            days * chromium_ai(params),
      copper:              days * copper_rda(params),
      iodine:              days * iodine_rda(params),
      iron:                days * iron_rda(params),
      magnesium:           days * magnesium_rda(params),
      manganese:           days * manganese_ai(params),
      molybdenum:          days * molybdenum_rda(params),
      phosphorus:          days * phosphorus_rda(params),
      potassium:           days * potassium_rda(params),
      selenium:            days * selenium_rda(params),
      zinc:                days * zinc_rda(params),

      # other nutrients
      choline:           days * choline_ai(params),
      o3_epa_dha:        days * o3_epa_dha_dpa_rda(params)
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
    cond do 
      activity == 0                 -> 1.2
      activity > 0 and activity < 3 -> 1.375
      activity > 2 and activity < 6 -> 1.55
      activity > 5 and activity < 8 -> 1.725
      activity > 7                  -> 1.9
    end
  end

  # https://en.wikipedia.org/wiki/Harris%E2%80%93Benedict_equation
  def baseline_metabolic_rate(%{
    :weight => weight,
    :height => height,
    :age => age,
    :sex => sex}) do 
      (10 * weight) + (6.25 * height) - (5 * age) + modifier(sex) 
  end

  def modifier(sex) do
    case sex do
     "female" -> -161
      "male"  -> 5
       _      -> -76
    end
  end

  # g/day
  def protein_rdi(%{:weight => weight, :age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> round(1.08 * weight)
      age > 3 and age < 9   -> round(0.91 * weight)
      age > 8 and age < 14  -> round(0.94 * weight)
      age > 13 and age < 19 -> round(0.99 * weight)
      age > 18 and age < 71 -> round(0.84 * weight)
      age > 70              -> round(1.07 * weight)
    end
  end
  def protein_rdi(%{:weight => weight, :age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> round(1.08 * weight)
      age > 3 and age < 9   -> round(0.91 * weight)
      age > 8 and age < 14  -> round(0.87 * weight)
      age > 13 and age < 19 -> round(0.77 * weight)
      age > 18 and age < 71 -> round(0.75 * weight)
      age > 70              -> round(0.94 * weight)
    end
  end
  def protein_rdi(%{:weight => weight, :age => age}) do
    cond do
      age > 0 and age < 4   -> round(1.08 * weight)
      age > 3 and age < 9   -> round(0.91 * weight)
      age > 8 and age < 14  -> round(0.9 * weight)
      age > 13 and age < 19 -> round(0.88 * weight)
      age > 18 and age < 71 -> round(0.8 * weight)
      age > 70              -> weight
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

  def niacin_ne_rda(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 6
      age > 3 and age < 9   -> 8
      age > 8 and age < 14  -> 12
      age > 13              -> 16
    end
  end
  def niacin_ne_rda(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 6
      age > 3 and age < 9   -> 8
      age > 8 and age < 14  -> 12
      age > 13              -> 14
    end
  end
  def niacin_ne_rda(%{:age => age, :sex => sex}) do
    cond do
      age > 0 and age < 4   -> 6
      age > 3 and age < 9   -> 8
      age > 8 and age < 14  -> 12
      age > 13              -> 15
    end
  end

  def pantothenic_acid_ai(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 2
      age > 3 and age < 9   -> 3
      age > 8 and age < 14  -> 4
      age > 13              -> 5
    end
  end

  def riboflavin_rda(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 0.5
      age > 3 and age < 9   -> 0.6
      age > 8 and age < 14  -> 0.9
      age > 13              -> 1.3
      age > 18              -> 1.3
    end
  end
  def riboflavin_rda(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 0.5
      age > 3 and age < 9   -> 0.6
      age > 8 and age < 14  -> 0.9
      age > 13              -> 1.0
      age > 18              -> 1.1
    end
  end
  def riboflavin_rda(%{:age => age, :sex => sex}) do
    cond do
      age > 0 and age < 4   -> 0.5
      age > 3 and age < 9   -> 0.6
      age > 8 and age < 14  -> 0.9
      age > 13              -> 1.15
      age > 18              -> 1.2
    end
  end

  def thiamin_rda(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 0.5
      age > 3 and age < 9   -> 0.6
      age > 8 and age < 14  -> 0.9
      age > 13              -> 1.2
    end
  end
  def thiamin_rda(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 0.5
      age > 3 and age < 9   -> 0.6
      age > 8 and age < 14  -> 0.9
      age > 13              -> 1.0
      age > 18              -> 1.1
    end
  end
  def thiamin_rda(%{:age => age, :sex => sex}) do
    cond do
      age > 0 and age < 4   -> 0.5
      age > 3 and age < 9   -> 0.6
      age > 8 and age < 14  -> 0.9
      age > 13              -> 1.1
      age > 18              -> 1.15
    end
  end

  def vitamin_a_rae_rda(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 0.3
      age > 3 and age < 9   -> 0.4
      age > 8 and age < 14  -> 0.6
      age > 13              -> 0.9
    end
  end
  def vitamin_a_rae_rda(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 0.3
      age > 3 and age < 9   -> 0.4
      age > 8 and age < 14  -> 0.6
      age > 13              -> 0.7
    end
  end
  def vitamin_a_rae_rda(%{:age => age, :sex => sex}) do
    cond do
      age > 0 and age < 4   -> 0.3
      age > 3 and age < 9   -> 0.4
      age > 8 and age < 14  -> 0.6
      age > 13              -> 0.8
    end
  end

  #preformed vitamin A from supplements
  def vitamin_a_rae_ul(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 0.6
      age > 3 and age < 9   -> 0.9
      age > 8 and age < 14  -> 1.7
      age > 13              -> 2.8 #???
      age > 18              -> 3.0
    end
  end
  
  def vitamin_b6_rda(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 0.5
      age > 3 and age < 9   -> 0.6
      age > 8 and age < 14  -> 1.0
      age > 13 and age < 51 -> 1.3
      age > 50              -> 1.7
    end
  end
  def vitamin_b6_rda(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 0.5
      age > 3 and age < 9   -> 0.6
      age > 8 and age < 14  -> 1.0
      age > 13 and age < 19 -> 1.2
      age > 13 and age < 51 -> 1.3
      age > 50              -> 1.5
    end
  end
  def vitamin_b6_rda(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 0.5
      age > 3 and age < 9   -> 0.6
      age > 8 and age < 14  -> 1.0
      age > 13 and age < 19 -> 1.25
      age > 13 and age < 51 -> 1.3
      age > 50              -> 1.6
    end
  end
  
  def vitamin_b12_rda(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 0.0009
      age > 3 and age < 9   -> 0.0012
      age > 8 and age < 14  -> 0.0018
      age > 13              -> 0.0024
    end
  end

  def vitamin_c_rda(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 15
      age > 3 and age < 9   -> 25
      age > 8 and age < 14  -> 45
      age > 13 and age < 19 -> 75
      age > 18              -> 90
    end
  end
  def vitamin_c_rda(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 15
      age > 3 and age < 9   -> 25
      age > 8 and age < 14  -> 45
      age > 13 and age < 19 -> 65
      age > 18              -> 75
    end
  end
  def vitamin_c_rda(%{:age => age, :sex => sex}) do
    cond do
      age > 0 and age < 4   -> 15
      age > 3 and age < 9   -> 25
      age > 8 and age < 14  -> 45
      age > 13 and age < 19 -> 70
      age > 18              -> 82.5
    end
  end

  def vitamin_c_lp_recc(%{:age => age, :sex => sex}) do
    cond do
      age > 0 and age < 4   -> 70
      age > 3 and age < 9   -> 110
      age > 8 and age < 14  -> 200
      age > 13 and age < 19 -> 335
      age > 18              -> 400
    end
  end
  
  def vit_e_a_tocopherol_rda(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 6
      age > 3 and age < 9   -> 7
      age > 8 and age < 14  -> 11
      age > 13              -> 15
    end
  end
  def vit_e_a_tocopherol_rda(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 6
      age > 3 and age < 9   -> 7.5
      age > 8 and age < 14  -> 11
      age > 13              -> 15
    end
  end
  def vit_e_a_tocopherol_rda(%{:age => age, :sex => sex}) do
    cond do
      age > 0 and age < 4   -> 6
      age > 3 and age < 9   -> 7.25
      age > 8 and age < 14  -> 11
      age > 13              -> 15
    end
  end

  #K1
  def vitamin_k1_ai(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 0.030
      age > 3 and age < 9   -> 0.055
      age > 8 and age < 14  -> 0.060
      age > 13 and age < 19 -> 0.075
      age > 18              -> 0.120
    end
  end
  def vitamin_k1_ai(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 0.030
      age > 3 and age < 9   -> 0.055
      age > 8 and age < 14  -> 0.060
      age > 13 and age < 19 -> 0.075
      age > 18              -> 0.090
    end
  end
  def vitamin_k1_ai(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 0.030
      age > 3 and age < 9   -> 0.055
      age > 8 and age < 14  -> 0.060
      age > 13 and age < 19 -> 0.075
      age > 18              -> 0.105
    end
  end
 

  #minerals

  def calcium_rda(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 700
      age > 3 and age < 9   -> 1000
      age > 8 and age < 19  -> 1300
      age > 18 and age < 71 -> 1000
      age > 70              -> 1200
    end
  end
  def calcium_rda(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 700
      age > 3 and age < 9   -> 1000
      age > 8 and age < 19  -> 1300
      age > 18 and age < 51 -> 1000
      age > 50              -> 1200
    end
  end
  def calcium_rda(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 700
      age > 3 and age < 9   -> 1000
      age > 8 and age < 19  -> 1300
      age > 18 and age < 51 -> 1000
      age > 50 and age < 71 -> 1100
      age > 70              -> 1200
    end
  end
  
  def chromium_ai(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 0.011
      age > 3 and age < 9   -> 0.015
      age > 8 and age < 19  -> 0.025
      age > 18 and age < 51 -> 0.035
      age > 50              -> 0.03
    end
  end
  def chromium_ai(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 0.011
      age > 3 and age < 9   -> 0.015
      age > 8 and age < 14  -> 0.021
      age > 13 and age < 19 -> 0.024
      age > 18 and age < 51 -> 0.025
      age > 50              -> 0.02
    end
  end
  def chromium_ai(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 0.011
      age > 3 and age < 9   -> 0.015
      age > 8 and age < 14  -> 0.023
      age > 13 and age < 19 -> 0.0245
      age > 18 and age < 51 -> 0.03
      age > 50              -> 0.025
    end
  end
  
  def copper_rda(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 0.34
      age > 3 and age < 9   -> 0.44
      age > 8 and age < 14  -> 0.7
      age > 13 and age < 19 -> 0.89
      age > 18              -> 0.9
    end
  end
  
  def iodine_rda(%{:age => age}) do
    cond do
      age > 0 and age < 9   -> 0.09
      age > 8 and age < 14  -> 0.12
      age > 13              -> 0.150
    end
  end
  
  def iron_rda(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 7
      age > 3 and age < 9   -> 10
      age > 8 and age < 14  -> 8
      age > 13 and age < 19 -> 11
      age > 18              -> 8
    end
  end
  def iron_rda(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 7
      age > 3 and age < 9   -> 10
      age > 8 and age < 14  -> 8
      age > 13 and age < 19 -> 15
      age > 18 and age < 51 -> 18
      age > 50              -> 8
    end
  end
  def iron_rda(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 7
      age > 3 and age < 9   -> 10
      age > 8 and age < 14  -> 8
      age > 13 and age < 19 -> 13
      age > 18 and age < 51 -> 15
      age > 50              -> 8
    end
  end
  
  def magnesium_rda(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 80
      age > 3 and age < 9   -> 130
      age > 8 and age < 14  -> 240
      age > 13 and age < 19 -> 410
      age > 18 and age < 31 -> 400
      age > 30              -> 420
    end
  end
  def magnesium_rda(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 80
      age > 3 and age < 9   -> 130
      age > 8 and age < 14  -> 240
      age > 13 and age < 19 -> 360
      age > 18 and age < 31 -> 310
      age > 30              -> 320
    end
  end
  def magnesium_rda(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 80
      age > 3 and age < 9   -> 130
      age > 8 and age < 14  -> 240
      age > 13 and age < 19 -> 385
      age > 18 and age < 31 -> 355
      age > 30              -> 370
    end
  end
  
  def manganese_ai(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 1.2
      age > 3 and age < 9   -> 1.5
      age > 8 and age < 14  -> 1.9
      age > 13 and age < 19 -> 2.2
      age > 18              -> 2.3
    end
  end
  def manganese_ai(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 1.2
      age > 3 and age < 9   -> 1.5
      age > 8 and age < 14  -> 1.6
      age > 13 and age < 19 -> 1.6
      age > 18              -> 1.8
    end
  end
  def manganese_ai(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 1.2
      age > 3 and age < 9   -> 1.5
      age > 8 and age < 14  -> 1.75
      age > 13 and age < 19 -> 1.9
      age > 18              -> 2.05
    end
  end
  
  def molybdenum_rda(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 0.017
      age > 3 and age < 9   -> 0.022
      age > 8 and age < 14  -> 0.034
      age > 13 and age < 19 -> 0.043
      age > 18              -> 0.045
    end
  end
  
  def phosphorus_rda(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 460
      age > 3 and age < 9   -> 500
      age > 8 and age < 14  -> 1250
      age > 13              -> 700
    end
  end

  def potassium_rda(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 3000
      age > 3 and age < 9   -> 3800
      age > 8 and age < 14  -> 4500
      age > 13              -> 4700
    end
  end
  
  def selenium_rda(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 0.020
      age > 3 and age < 9   -> 0.030
      age > 8 and age < 14  -> 0.040
      age > 13              -> 0.055
    end
  end
  
  def selenium_ul(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 0.090
      age > 3 and age < 9   -> 0.150
      age > 8 and age < 14  -> 0.280
      age > 13              -> 0.400
    end
  end

  #http://thepaleodiet.com/new-studies-on-salt-adverse-influence-upon-immunity-inflammation-and-autoimmunity/ 
  # http://www.marksdailyapple.com/salt-what-is-it-good-for/
  # def sodium_ul(%{:age => age}) do
  #   cond do
  #     age > 0 and age < 4   -> 1500
  #     age > 3 and age < 9   -> 1900
  #     age > 8 and age < 14  -> 2200
  #     age > 13              -> 2300
  #   end
  # end
  
  def zinc_rda(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 3
      age > 3 and age < 9   -> 5
      age > 8 and age < 14  -> 8
      age > 18              -> 11
    end
  end
  def zinc_rda(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 3
      age > 3 and age < 9   -> 5
      age > 8 and age < 14  -> 8
      age > 13 and age < 19 -> 9
      age > 18              -> 8
    end
  end
  def zinc_rda(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 3
      age > 3 and age < 9   -> 5
      age > 8 and age < 14  -> 8
      age > 13 and age < 19 -> 10
      age > 18              -> 9.5
    end
  end

  
  #Other nutrients


  def choline_ai(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 200
      age > 3 and age < 9   -> 250
      age > 8 and age < 14  -> 375
      age > 14              -> 550  
    end
  end
  def choline_ai(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 200
      age > 3 and age < 9   -> 250
      age > 8 and age < 14  -> 375
      age > 13 and age < 19 -> 400
      age > 18              -> 425
    end
  end
  def choline_ai(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 200
      age > 3 and age < 9   -> 250
      age > 8 and age < 14  -> 375
      age > 13 and age < 19 -> 475
      age > 18              -> 487.5
    end
  end

  # Australian and NZ Health authorities
  def o3_epa_dha_dpa_rda(%{:age => age, :sex => sex}) when sex == "male" do
    cond do
      age > 0 and age < 4   -> 40
      age > 3 and age < 9   -> 55
      age > 8 and age < 14  -> 70
      age > 14 and age < 19 -> 125
      age > 18              -> 160
    end
  end
  def o3_epa_dha_dpa_rda(%{:age => age, :sex => sex}) when sex == "female" do
    cond do
      age > 0 and age < 4   -> 40
      age > 3 and age < 9   -> 55
      age > 8 and age < 14  -> 70
      age > 13 and age < 19 -> 85
      age > 18              -> 90
    end
  end
  def o3_epa_dha_dpa_rda(%{:age => age}) do
    cond do
      age > 0 and age < 4   -> 40
      age > 3 and age < 9   -> 55
      age > 8 and age < 14  -> 70
      age > 13 and age < 19 -> 105
      age > 18              -> 125
    end
  end
end
