# Mastermind

Mastermind is a code braking game. The "code maker" creates a "code" of four colored pegs, any number of the same color in any order. The "code breaker" then guesses the code.

Hints are given to the code breaker by the code maker. Black pegs indicate there is a peg of the correct corresponding color in the correct position. White pegs indicate there is a peg of the correct corresponding color but the peg is in the incorrect position.

When the code breaker guesses the exact order of the code, the game is over.

Peg colors: green, red, blue, yellow, purple, orange

Hint pegs:

    black: correct color in the correct position
    white: correct color in the incorrect position

For more: http://www.wikihow.com/Play-Mastermind

## To play

Run `iex -S mix`

> Mastermind.start

Enter four colors for your guess.

**TODO**

1. Validate bad input and give meaningful error messages
1. escript so iex isn't necessary
