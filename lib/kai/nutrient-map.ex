defmodule Kai.NutrientNameMap do

  def nzff do 
    %{
      "Food Name" => :name,
      "FoodID" => :data_source_id,
      "Chapter" => :category,
      "Alpha-tocopherol" => :vit_e_a_tocopherol,
      "Biotin" => :biotin,
      "Calcium" => :calcium,
      "Chromium" => :chromium,
      "Copper" => :copper,
      "Dietary folate equivalents" => :folate_dfe,
      "Edible portion" => :edible_portion,
      "Energy; total metabolisable (kcal)" => :calories,
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
      "Niacin equivalents; total" => :niacin_ne,
      "Pantothenic acid" => :pantothenic_acid,
      "Phosphorus" => :phosphorus,
      "Potassium" => :potassium,
      "Protein; total; calculated from total nitrogen" => :protein,
      "Riboflavin" => :riboflavin,
      "Selenium" => :selenium,
      "Thiamin" => :thiamin,
      "Vitamin A; retinol equivalents" => :vitamin_a_rae,
      "Vitamin B12" => :vitamin_b12,
      "Vitamin B6" => :vitamin_b6,
      "Vitamin C" => :vitamin_c,
      "Vitamin E; alpha-tocopherol equivalents" => :vit_e_a_tocopherol,
      "Vitamin K" => :vitamin_k1,
      "Zinc" => :zinc



      }
  end

  # -> mg/100g
  def nzff_conversion do
    %{
      #mcg/100g
      "Biotin" => 0.001,
      "Chromium" => 0.001,
      "Edible portion" => 0.01,
      "Dietary folate equivalents" => 0.001,
      "Iodine" => 0.001,
      "Lithium" => 0.001,
      "Manganese" => 0.001,
      "Mercury" => 0.001,
      "Molybdenum" => 0.001,
      "Selenium" => 0.001,
      "Vitamin A, retinol equivalents" => 0.001,
      "Vitamin B12" => 0.001,
      "Vitamin K" => 0.001,

      #g/100g
      #"Fatty acid 20:5 omega-3" => 1000,
      #"Fatty acid 22:5 omega-3" => 1000,
      #"Fatty acid 22:6 omega-3" => 1000,
    }
  end






end

