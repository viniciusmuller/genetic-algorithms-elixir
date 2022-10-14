defmodule Genetic do
  @moduledoc """
  Documentation for `Genetic`.
  """

  defmodule Context do
    defstruct [:fitness_function, :genotype, :max_fitness, population_size: 100]
  end

  def run(ctx = %Context{}) do
    initialize(ctx.genotype, ctx.population_size)
    |> evolve(ctx)
  end

  def initialize(genotype, population_size) do
    for _ <- 1..population_size, do: genotype.()
  end

  def evaluate(population, fitness_function) do
    Enum.sort_by(population, fitness_function, &>=/2)
  end

  def select(population) do
    population
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
  end

  def crossover(population) do
    Enum.reduce(population, [], fn {p1, p2}, acc ->
      cx_point = :rand.uniform(length(p1))
      # split and swap parts of the chromosomes (in this case, lists)
      {{h1, t1}, {h2, t2}} = {Enum.split(p1, cx_point), Enum.split(p2, cx_point)}
      {c1, c2} = {h1 ++ t2, h2 ++ t1}
      [c1, c2 | acc]
    end)
  end

  def mutation(population) do
    Enum.map(population, fn chromosome ->
      # 5% of mutating a chromosome
      if :rand.uniform() < 0.05 do
        Enum.shuffle(chromosome)
      else
        chromosome
      end
    end)
  end

  def evolve(population, ctx) do
    population = evaluate(population, ctx.fitness_function)
    best = hd(population)
    IO.write("\nCurrent best: #{ctx.fitness_function.(best)}")

    if ctx.fitness_function.(best) == ctx.max_fitness do
      best
    else
      population
      |> select()
      |> crossover()
      |> mutation()
      |> evolve(ctx)
    end
  end
end
