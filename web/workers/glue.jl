
#odules
using DataArrays, DataFrames, JuMP, Cbc
showln(x) = (show(x); println())

# functions
function lookup(df, col_index, lookup_ary, result_ary) 
  column_name_at_index = names(df)[col_index]
  lookup_index = find(lookup_ary .== column_name_at_index)[1]

  result_ary[lookup_index]
end


# load data
constraints_raw = readtable("$(pwd())/web/workers/constraints.csv")
foods_raw = readtable("$(pwd())/web/workers/foods.csv")


# arrays
nutrients_raw = map(symbol, constraints_raw[:nutrient])
food_nutrients = names(foods_raw)
nutrients = intersect(food_nutrients, nutrients_raw)


# main
food_names = foods_raw[:name]
prices = foods_raw[:price_100g]

foods = foods_raw[:, nutrients]
constraints = constraints_raw[findin(nutrients_raw, nutrients), :] 

sufficiencies = constraints[:amount]


# reporting dataframe
columns = [nutrients; [:name, :price_100g]]
foods_info = foods_raw[:, columns]


# constants
food_count = length(food_names)
nutrient_count = length(nutrients)


# variables
quantities = fill(100, food_count)


## setup model
m = Model(solver = CbcSolver(logLevel = 1))
@variable(m, quantities[1:length(food_names)] >= 0, Int)

# constraints 
#i = column index; j = row index
for i in 1:nutrient_count
  @constraint(
    m, 
    (sum([foods[j, i] * quantities[j] for j in 1:food_count])
      / lookup(foods, i, nutrients, sufficiencies)) >= 1
  )
end






## initial data
#food_names = ["bacon", "lettuce", "tomato"]
#prices = [6, 6, 7]
#quantities = [0, 0, 0]
#
#nutrient_names = ["c", "d", "k"]
#sufficiency = [100, 110, 130]
#
#nutrients = [
# # c   d   k
#  3.0 2.0 2.0; #bacon
#  2.0 4.5 2.5; #lettuce
#  1.0 1.0 7.0  #tomato
#]
#
#
## computed variables
#food_count = length(food_names)
#nutrient_count = length(nutrient_names)
#
#
## setup model
#m = Model(solver = CbcSolver(logLevel = 1))
#@variable(m, quantities[1:food_count] >= 0, Int)
#
#for i in 1:nutrient_count
#  @constraint(
#    m, 
#    sum([nutrients[j, i] * quantities[j] for j in 1:food_count])
#      / sufficiency[i] >= 1
#  )
#end
#
#@objective(m, Min, sum([quantities[i] * prices[i] for i in 1:food_count]))
#
#
## solve
#status = solve(m)
#println("Status = $status")
#println("Optimal Objective Function value: ", getobjectivevalue(m))
#println("Optimal Solutions:")
#solution = getvalue(quantities)
#println("quantities = ", solution)
#
#for i in 1:nutrient_count
#  println(nutrient_names[i], ": ")
#  println(sum([nutrients[j, i] * solution[j] for j in 1:food_count]))
#end
#



