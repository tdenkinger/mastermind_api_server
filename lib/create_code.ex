defmodule Mastermind.CreateCode  do
  @code_pegs [:green, :red, :blue, :yellow, :purple, :orange]

  def new(count \\ 4) do
    Range.new(1, count)
    |> Enum.reduce([], fn(_, code) -> [Enum.random(@code_pegs) | code] end)
  end
end
