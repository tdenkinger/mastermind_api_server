defmodule MastermindTest do
  use ExUnit.Case, async: true

  test "a game can start" do
    {:ok, game} = Mastermind.start()

    assert is_pid(game)
  end

  test "sets a code at game start" do
    {:ok, game} = Mastermind.start()

    code = Mastermind.code(game)
    refute Enum.empty?(code)
  end

  test "allows a specific code to be set at game start" do
    {:ok, game} = Mastermind.start([:x, :x, :x, :x])

    code = Mastermind.code(game)

    assert code == [:x, :x, :x, :x]
  end

  test "creates a random code if the code passed in is not a list" do
    {:ok, game} = Mastermind.start({:x, :x, :x, :x})

    code = Mastermind.code(game)

    refute code == [:x, :x, :x, :x]
  end

  test "returns a solved status when the guess is correct" do
    {:ok, game} = Mastermind.start()

    guess  = Mastermind.code(game)
    status = Mastermind.guess(game, guess)

    assert status == "Solved"
  end

  test "returns 'unsolved' status when the guess is not correct" do
    {:ok, game} = Mastermind.start()

    status = Mastermind.guess(game, [:x, :x, :x, :x])

    assert status == "Unsolved"
  end

  test "Turn history starts empty" do
    {:ok, game} = Mastermind.start()

    hints = Mastermind.turns(game)

    assert hints == []
  end

  test "History accumulates each turn" do
    {:ok, game} = Mastermind.start()

    Mastermind.guess(game, [:x, :x, :x, :x])
    turns = Mastermind.turns(game)

    assert turns == [%{guess: [:x, :x, :x, :x], hint: []}]

    Mastermind.guess(game, [:y, :x, :z, :x])

    turns = Mastermind.turns(game)

    assert turns == [%{guess: [:y, :x, :z, :x], hint: []},
                     %{guess: [:x, :x, :x, :x], hint: []}
                    ]
  end

  test "hints have only white pegs when colors are correct, position is not" do
    {:ok, game} = Mastermind.start([:blue,   :green, :red,  :blue])
    Mastermind.guess(game,         [:orange, :blue,  :blue, :pink])

    turns = Mastermind.turns(game)

    assert List.first(turns).hint == [:white, :white]
  end

  test "hints have only black pegs when positions are correct" do
    {:ok, game} = Mastermind.start([:blue, :green,  :red, :blue])
    Mastermind.guess(game,         [:blue, :orange, :red, :pink])

    turns = Mastermind.turns(game)

    assert List.first(turns).hint == [:black, :black]
  end

  test "hints can have both black and white pegs" do
    {:ok, game} = Mastermind.start([:blue, :green,  :red, :blue])
    Mastermind.guess(game,         [:blue, :orange, :red, :green])

    turns = Mastermind.turns(game)

    assert List.first(turns).hint == [:black, :black, :white]
  end

  test "guessing a color twice when it only appears once in the code should
        only return one hint" do
    {:ok, game} = Mastermind.start([:blue, :orange, :red,    :pink])
    Mastermind.guess(game,         [:blue, :blue,  :orange, :orange])

    turns = Mastermind.turns(game)

    assert List.first(turns).hint == [:black, :white]
  end
end
