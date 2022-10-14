population =
  for _ <- 1..100 do
    for _ <- 1..1000, do: Enum.random(0..1)
  end

defmodule OneMax do
  def solve(population) do
    population
    |> evaluate()
    |> selection()
    |> crossover()
    |> algorithm()
  end

  defp algorithm(population) do
    best = Enum.max_by(population, &Enum.sum/1)
    IO.write("Current best: #{Enum.sum(best)}")

    if Enum.sum(best) == 100 do
      best
    else
    end
  end

  defp evaluate(population) do 

  end

  defp selection(population) do 

  end

  defp crossover(population) do 

  end
end
