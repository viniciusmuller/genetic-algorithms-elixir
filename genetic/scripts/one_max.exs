bitstring_length = 1000
genotype = fn -> for _ <- 1..bitstring_length, do: Enum.random(0..1) end

solution = Genetic.run(%Genetic.Context{
  genotype: genotype,
  fitness_function: &Enum.sum/1,
  max_fitness: bitstring_length,
  population_size: 200
})

IO.inspect(solution)
