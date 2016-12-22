defmodule Kai.NutrientNameMap do

  def nzff do 
    %{
      "Food Name" => :name,
      "Alpha-tocopherol" => :vit_e_a_tocopherol,
      "Biotin" => :biotin,
      "Calcium" => :calcium,
      "Chromium" => :chromium,
      "Copper" => :copper,
      "Dietary folate equivalents" => :folate_dfe,
      "Edible portion" => :edible_portion,
      "Energy, total metabolisable (kcal)" => :calories,
      "Fatty acid 20:5 omega-3" => :o3_epa,
      "Fatty acid 22:5 omega-3" => :o3_dpa,
      "Fatty acid 22:6 omega-3" => :o3_dha,
      "Iodide" => :iodine,
      "Iron" => :iron,
      "Lithium" => :lithium,
      "Magnesium" => :magnesium,
      "Manganese" => :manganese,
      "Mercury" => :mercury,
      "Molybdenum" => :molybdenum,
      "Niacin equivalents, total" => :niacin_ne,
      "Pantothenic acid" => :pantothenic_acid,
      "Phosphorus" => :phosphorus,
      "Potassium" => :potassium,
      "Protein, total; calculated from total nitrogen" => :protein,
      "Riboflavin" => :riboflavin,
      "Selenium" => :selenium,
      "Thiamin" => :thiamin,
      "Vitamin A, retinol equivalents" => :vitamin_a_rae,
      "Vitamin B12" => :vitamin_b12,
      "Vitamin B6" => :vitamin_b6,
      "Vitamin C" => :vitamin_c,
      "Vitamin E, alpha-tocopherol equivalents" => :vit_e_a_tocopherol,
      "Vitamin K" => :vitamin_k1,
      "Zinc" => :zinc



      }
  end

  # -> mg/100g
  def nzff_conversion do
    %{
      #mcg/100g
      :biotin => 0.001,
      :chromium => 0.001,
      :edible_portion => 0.01,
      :folate_dfe => 0.001,
      :iodine => 0.001,
      :lithium => 0.001,
      :manganese => 0.001,
      :mercury => 0.001,
      :molybdenum => 0.001,
      :selenium => 0.001,
      :vitamin_a_rae => 0.001,
      :vitamin_b12 => 0.001,
      :vit_e_a_tocopherol => 0.001,
      :vitamin_k1 => 0.001,

      #g/100g
      :o3_epa => 1000,
      :o3_dha => 1000, 
      :o3_dpa => 1000
    }
  end






end

