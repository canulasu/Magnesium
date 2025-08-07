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

            echo "You are now exiting the help utility to the Magnesium Language live runtime environment."

            break

        elif prompt == "println":
            echo "Function: println()"
            echo "Arguments: 1"
            echo "Usage: println(arguments)"
            echo "Accepts: Addition, variables, strings, integers, floats"
            echo "Description: Prints a line to the console."

        elif prompt == "os.system":
            echo "Function: os.system()"
            echo "Arguments: 1"
            echo "Usage: os.system(command)"
            echo "Accepts: Addition, variables, strings, integers, floats"
            echo "Description: Runs a command on the system shell."

        elif prompt == "var":
            echo "Keyword: var"
            echo "Arguments: 2"
            echo "Usage: var name = contents"
            echo "Accepts: Addition, variables, strings, integers, floats"
            echo "Description: Used to local declare variables."

        elif prompt == "include":
            echo "Keyword: include"
            echo "Arguments: 1"
            echo "Usage: include name"
            echo "Accepts: Standard library modules or Magnesium scripts."
            echo "Description: Used to globally import libraries or modules."

    return 0
