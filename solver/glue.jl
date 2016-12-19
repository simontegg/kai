using DataArrays, DataFrames

inn = ARGS
#inn2 = parse(UInt8, readline())

#write(STDOUT, "inn2 $inn2")

intake = readtable("intake.csv")

println(intake)

write(STDOUT, intake)

