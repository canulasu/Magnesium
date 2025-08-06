import std/strutils
import terminal

proc helpmode*(): int =

    echo "Welcome to Magnesium 0.0.1's assistance script!"
    echo "The the name of any keyword or module without parenthesis or arguments to learn more about it."
    echo "Type exit to exit"

    while true:

        setForegroundColor(fgBlue)
        stdout.write("help> ")
        resetAttributes()

        var prompt = readLine(stdin).strip()

        if prompt == "exit":
            break

        elif prompt == "println":
            echo "Function: println()"
            echo "Arguments: 1"
            echo "Usage: println(arguments)"
            echo "Accepts: Addition, variables, strings"

    return 0