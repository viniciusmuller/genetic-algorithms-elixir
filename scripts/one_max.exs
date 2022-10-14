population =
  for _ <- 1..100 do
    for _ <- 1..1000, do: Enum.random(0..1)
  end

defmodule OneMax do
  def solve(population, parent) do
    result = algorithm(population, 1)
    send(parent, {:finished, result, self()})
  end

  defp algorithm(population, generation) do
    best = Enum.max_by(population, &Enum.sum/1)

    if rem(generation, 250) == 0 do
      IO.write("Generation #{generation} - Current best: #{Enum.sum(best)}\n")
    end

    if Enum.sum(best) == 1000 do
      {generation, best}
    else
      population
      |> fitness()
      |> selection()
      |> crossover()
      |> mutation()
      |> algorithm(generation + 1)
    end
  end

  defp fitness(population) do
    Enum.sort_by(population, &Enum.sum/1, &>=/2)
  end

  # Mutation is necessary to prevent the parents to get genetically too similar,
  # thus preventing premature convergence.
  defp mutation(population) do
    Enum.map(population, fn chromosome ->
      # with a random and low probability, we might mutate a chromosome
      if :rand.uniform() < 0.05 do
        Enum.shuffle(chromosome)
      else
        chromosome
      end
    end)
  end

  defp selection(population) do
    population
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
  end

  defp crossover(population) do
    Enum.reduce(population, [], fn {p1, p2}, acc ->
      cx_point = :rand.uniform(1000)
      # This tends to improve since we are crossing two chromosomes with great
      # performance, so it tends to be more ones than zeros
      {{h1, t1}, {h2, t2}} = {Enum.split(p1, cx_point), Enum.split(p2, cx_point)}

      [h1 ++ t2, h2 ++ t1 | acc]
    end)
  end
end

for _ <- 1..2 do
  parent = self()
  pid = spawn(fn -> OneMax.solve(population, parent) end)
  IO.inspect(pid)
end

for _ <- 1..2 do
  receive do
    {:finished, {gen, result}, worker} ->
      IO.inspect("Worker #{inspect(worker)} finished at generation #{gen}")
  end
end
