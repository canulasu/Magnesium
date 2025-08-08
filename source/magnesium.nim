import os
import parser
import std/strutils
import interpreter
import terminal
import help
import version

if paramCount() < 1:

    echo "Magnesium Runtime " & version() & " [Implemented using Nim-Lang 2.2.4]"
    echo "Copyright 2025 canulasu (canulasunal@proton.me)"
    echo "Type \"help\" or \"copyright\" for more information"

    var variables: seq[string] = @[]

    while true:

        setForegroundColor(fgRed)
        stdout.write(">>> ")
        resetAttributes()

        var repl = readLine(stdin)

        if repl.strip() == "help":
            discard helpmode()

        if repl.strip() == "copyright":
            echo "Copyright (c) 2025 canulasu."
            echo "All rights reserved."

        if repl.startsWith("var "):
            variables.add(repl)
        if repl.startsWith("include "):
            variables.add(repl)

        elif repl.startsWith("exit ") or repl.strip() == "exit":
            echo "Use exit() or Ctrl-Z to exit"
            continue

        for item in variables:
            repl = variables.join(";") & ";" & repl

        discard interpret(parserepl(repl))

let command = paramStr(1)

if command == "--version" or command == "-V":
    echo "Magnesium Runtime Version 0.0.1"
    echo "Copyright (c) 2025 canulasu"
    echo ""
    echo "Released under Apache License Version 2.0"

else:
    
    let filename = paramStr(1)

    if filename.endsWith(".mg"):
        discard
    else:
        echo "E: Incorrect file extension. Magnesium files need to end with .mg"
        quit(1)

    var document = parse(filename)

    discard interpret(document)
