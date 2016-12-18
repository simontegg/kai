#Modules
using JuMP
using Cbc


# initial data
food_names = ["bacon", "lettuce", "tomato"]
prices = [6, 6, 7]
quantities = [0, 0, 0]

nutrient_names = ["c", "d", "k"]
sufficiency = [100, 110, 130]

nutrients = [
 # c   d   k
  3.0 2.0 2.0; #bacon
  2.0 4.5 2.5; #lettuce
  1.0 1.0 7.0  #tomato
]


# computed variables
food_count = length(food_names)
nutrient_count = length(nutrient_names)


# setup model
m = Model(solver = CbcSolver(logLevel = 1))
@variable(m, quantities[1:food_count] >= 0, Int)

for i in 1:nutrient_count
  @constraint(
    m, 
    sum([nutrients[j, i] * quantities[j] for j in 1:food_count])
      / sufficiency[i] >= 1
  )
end

@objective(m, Min, sum([quantities[i] * prices[i] for i in 1:food_count]))


# solve
status = solve(m)
println("Status = $status")
println("Optimal Objective Function value: ", getobjectivevalue(m))
println("Optimal Solutions:")
solution = getvalue(quantities)
println("quantities = ", solution)

for i in 1:nutrient_count
  println(nutrient_names[i], ": ")
  println(sum([nutrients[j, i] * solution[j] for j in 1:food_count]))
end

