using JuMP
using Cbc

sufficiency = 100
quantities = [0, 0, 0]
nutrients = [3.5, 4, 3]
prices = [5, 10, 7]
len = length(quantities)
m = Model(solver=CbcSolver())
@variable(m, quantities[1:len] >= 0, Int)

@constraint(
	m, 
	sum([nutrients[i] * quantities[i] for i=1:len]) / sufficiency >= 1
)

@objective(m, Min, sum([quantities[i] * prices[i] for i=1:len]))
status = solve(m)
println("Status = $status")
println("Optimal Objective Function value: ", getobjectivevalue(m))
println("Optimal Solutions:")
println("quantities = ", getvalue(quantities))


