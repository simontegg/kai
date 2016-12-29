
#odules
using DataArrays, DataFrames, JuMP, Cbc, ECOS, GLPK
showln(x) = (show(x); println())


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

filtered = constraints_raw[findin(nutrients_raw, nutrients), :] 
s = map(symbol, filtered[:nutrient])
new_order = map((n) -> find(s .== n)[1], names(foods))

constraints = filtered[new_order, :]


# set calories minimum at 90% of maintenance
calories_index = find(constraints[:nutrient] .== "calories")
calories = constraints[calories_index, :amount]
constraints[calories_index, :amount] = round(calories * 0.9)

calories_max = round(10 * calories[1])
calories_min = round(0.9 * calories[1])


sufficiencies = constraints[:amount]
println(calories_max)


# reporting dataframe
columns = [nutrients; [:name, :price_100g]]
foods_info = foods_raw[:, columns]


# constants
food_count = length(food_names)
nutrient_count = length(nutrients)


# variables
quantities = fill(1, food_count)


# setup model
m = Model(solver = CbcSolver())
@variable(m, quantities[1:length(food_names)] >= 0)
#@variable(m, quantities[1:length(food_names)] >= 0)

# constraints 
#i = column index (nutrient); j = row index (food)
for i in 1:nutrient_count
  @constraint(
    m, 
    sum([foods[j, i] * quantities[j] for j in 1:food_count])
      >= constraints[:amount][i]
  )
end

@constraint(
  m, 
  sum([foods[j, :calories] * quantities[j] for j in 1:food_count])
    <= calories_max
)

##@constraint(
##  m, 
##  sum([foods[j, :calories] * quantities[j] for j in 1:food_count])
##    >= calories_min
##)
#
#
#
#
# objective
@objective(m, Min, sum([quantities[i] * prices[i] for i in 1:food_count]))

#
## solve
status = solve(m)
println("Status = $status")
println("Optimal Objective Function value: ", getobjectivevalue(m))
println("Optimal Solutions:")
q = getvalue(quantities) 
p = q .* prices
c = q .* foods[:, :calories]


raw = DataFrame(foods = food_names, quantities = round(q * 100), price = round(p), calories = round(c))

solution = raw[raw[:quantities] .> 0, :]

showln(solution)

n = []
t = []
l = []

for i in 1:nutrient_count
  nutrient = names(foods)[i]
  total = sum([foods[j, i] * q[j] for j in 1:food_count])
  level = constraints[:amount][i]

  push!(l, total / level)
  push!(n, nutrient)
  push!(t, total)
end

levels = DataFrame(nutrients = n, totals = t, level = l)

showall(levels)
