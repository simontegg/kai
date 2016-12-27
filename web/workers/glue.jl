
using DataArrays, DataFrames

inn = ARGS
#inn2 = parse(UInt8, readline())

write(STDOUT, "inn $inn")


constraints = readtable("$(pwd())/web/workers/intake.csv")
# nutrient:string | amount:int (mg/week) | min or max :string |


foods = readtable("$(pwd())/web/workers/foods.csv")
# food_id:string | food_name:string | cents_per_g:int | edible_proportion:float | nutrient_a:int (mg/kg) ... | calories:int (kcal/week) | protein:int (g/week)
#writetable("output.csv", intake)






