defmodule Mastermind do
  use GenServer

  # Public API

  def start(initial_code \\ :nil) do
    GenServer.start_link(__MODULE__, initial_code, [])
  end

  def code(pid) do
    GenServer.call(pid, :code)
  end

  def turns(pid) do
    GenServer.call(pid, :turns)
  end


  def guess(pid, guess) do
    GenServer.call(pid, {:guess, guess})
  end

  # Private Callbacks

  def init(initial_code) do
    code = case initial_code do
      _ when is_list(initial_code) -> initial_code
      _                            -> Mastermind.CreateCode.new
    end

    {:ok, %{code: code, turns: [], status: "Unsolved"}}
  end

  def handle_call(:code, _from, game) do
    {:reply, game.code, game}
  end

  def handle_call(:turns, _from, game) do
    {:reply, game.turns, game}
  end

  def handle_call({:guess, guess}, _from, game) do
    game = case evaluate_guess(guess, game.code) do
      {:ok, "match"} ->
        %{code: game.code,
          turns: game.turns,
          status: "Solved"
        }

      {:no_match, hint} ->
        %{code: game.code,
          turns: [%{hint: hint, guess: guess} | game.turns],
          status: game.status
        }
    end

    {:reply, game.status, game}
  end

  #Helper Functions

  defp evaluate_guess(guess, code) do
    cond do
      guess == code -> {:ok, "match"}
      true          -> {:no_match, set_hints(guess, code)}
    end
  end

  defp set_hints(guess, code) do
    set_hints(:black, guess, code) ++ set_hints(:white, guess, code)
  end

  defp set_hints(:black, guess, code) do
    Enum.zip(guess, code)
    |> Enum.filter(fn(pegs) -> elem(pegs, 0) == elem(pegs, 1) end)
    |> Enum.reduce([], fn(_, hints) -> [:black | hints] end)
  end

  defp set_hints(:white, guess, code) do
    Enum.zip(guess, code)
    |> Enum.filter(fn(pegs) -> elem(pegs, 0) != elem(pegs, 1) end)
    |> Enum.unzip
    |> set_white_hints
  end

  defp set_white_hints({guess, code}) do
    compile_white_hints({guess, code, 0})
  end

  defp compile_white_hints({[], _, match_count}) do
    List.duplicate(:white, match_count)
  end

  defp compile_white_hints({ [guess|guesses], code, match_count }) do
    case Enum.member?(code, guess) do
      :true -> increment_match_count(code, guess, guesses, match_count)
               |> compile_white_hints
          _ -> compile_white_hints({guesses, code, match_count})
    end
  end

  defp increment_match_count(code, guess, guesses, match_count) do
    {guesses, List.delete(code, guess), match_count + 1}
  end
end
