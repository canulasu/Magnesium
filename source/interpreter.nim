import std/strutils
import tables
import typelib
import os
import inteval
import parser

import stdlib/oslib
import stdlib/timelib

proc interpret*(codeContent: string): string =

    var oslib_imported = false
    var timelib_imported = false

    var document = codeContent
    var libraries: seq[string] = @[]

    for line in codeContent.split("\n"):
        if line.startswith("include "):
            if line.strip() == "include os":
                oslib_imported = true
            elif line.strip() == "include time":
                timelib_imported = true
            else:
                document = readFile(line.replace("include ", "") & ".mg") & "\n" & document
                libraries.add(line.replace("include ", "").strip())


    var functions: seq[string] = @[]
    var function_names: Table[string, int]

    var functioncounter = 0

    var strings: Table[string, string]
    var ints: Table[string, int]
    var floats: Table[string, float]

    var code = document.split("\n")

    var counter = 0
    var forbidden: seq[int] = @[]

    for command in code:

        if counter in forbidden:
            discard

        else:

            var indentation = 0

            for item in command.split():
                if item == ":*#$?!>-+":
                    indentation += 1

            var indent = $(indentation)
            var statement = command.replace(":*#$?!>-+ ", "").strip()

            if oslib_imported == true:
                statement = oslib.refresh(statement)

            if statement.startsWith("var "):
                var name = statement.replace("var ", "").split("=")[0].strip()
                var contents = statement.replace("var ", "").split("=")[1].strip()
                var vartype = types(contents)

                if contents.startswith("ask(") and contents.endsWith(")"):
                    contents =contents.replace("\"", "").replace("ask(")[0 ..^ 2]
                    stdout.write(contents)
                    var value = readLine(stdin)
                    strings[name] = value
                    continue

                for item in ints.keys:
                    var modifier = "$"&item
                    contents = contents.replace(modifier, $(ints[item]))

                try:
                    contents = $(evaluate(contents))
                except:
                    discard

                if vartype == "String":
                    strings[name] = contents.replace("\"", "")
                if vartype == "Int":
                    ints[name] = evaluate(contents)
                if vartype == "Float":
                    floats[name] = evaluate_float(contents)

            if statement.startsWith("println(") and statement.endsWith(")"):
                var parameters = statement.replace("println(", "").replace(")", "").strip()

                var stringType = strings.contains(parameters)
                var intType = ints.contains(parameters)

                if stringType == true:
                    echo strings[parameters]

                elif intType == true:
                    echo ints[parameters]

                else:
                    for item in ints.keys:
                        var modifier = "$"&item
                        parameters = parameters.replace(modifier, $(ints[item]))

                    for item in strings.keys:
                        var modifier = "$"&item
                        parameters = parameters.replace(modifier, $(strings[item]))

                    for item in floats.keys:
                        var modifier = "$"&item
                        parameters = parameters.replace(modifier, $(floats[item]))

                    try:
                        echo evaluate(parameters.replace("\"", ""))
                    except:
                        echo parameters.replace("\"", "")

            if statement.startsWith("exec(") and statement.endsWith(")"):
                var parameters = statement.replace("exec(", "").strip()[0 ..^ 2]

                var stringType = strings.contains(parameters)
                var intType = ints.contains(parameters)

                for item in ints.keys:
                    var modifier = "$"&item
                    parameters = parameters.replace(modifier, $(ints[item]))

                for item in strings.keys:
                    var modifier = "$"&item
                    parameters = parameters.replace(modifier, $(strings[item]))

                for item in floats.keys:
                    var modifier = "$"&item
                    parameters = parameters.replace(modifier, $(floats[item]))

                try:
                    discard interpret(parserepl($(evaluate(parameters.replace("\"", "")))))
                except:
                    discard interpret(parserepl($(parameters.replace("\"", ""))))
                    
            if statement.startsWith("function "):
                var name = statement.strip().replace("function ", "").replace("()", "").replace("{", "").strip()

                function_names[name] = functioncounter

                var index = code.find(statement)
                var functioncontent: seq[string] = @[]

                if oslib_imported == true:
                    functioncontent.add("include os")
                if timelib_imported == true:
                    functioncontent.add("include time")

                for item in libraries:
                    functioncontent.add("include " & item)

                for i in index + 1 ..< code.len:

                    var line = code[i]

                    var check = line.replace(":*#$?!>-+ ", "").strip()

                    if  "}" in check.strip().split():
                        break
                    if check.strip() == "{":
                        discard
                    else:
                        functioncontent.add(check)
                        forbidden.add(i)

                functions.add(functioncontent.join("\n"))

                functioncounter += 1

            if statement.startsWith("call "):
                var name = statement.strip().replace("call ", "").replace("()", "").replace("{", "").strip()

                try:
                    discard interpret(functions[function_names[name]])
                except:
                    echo "Bloodstone: Error on line " & $(counter) & ". Function does not exist."
                    quit(1)

            if oslib_imported == true:
                if statement.startsWith("os."):
                    var functionName = statement.replace("os.", "")

                    for item in ints.keys:
                        var modifier = "$"&item
                        functionName = functionName.replace(modifier, $(ints[item]))

                    for item in strings.keys:
                        var modifier = "$"&item
                        functionName = functionName.replace(modifier, $(strings[item]))

                    for item in floats.keys:
                        var modifier = "$"&item
                        functionName = functionName.replace(modifier, $(floats[item]))

                    functionName = functionName.replace("\"", "")

                    discard oslib.runtime(functionName)

            if timelib_imported == true:
                if statement.startsWith("time."):
                    var functionName = statement.replace("time.", "")

                    for item in ints.keys:
                        var modifier = "$"&item
                        functionName = functionName.replace(modifier, $(ints[item]))

                    for item in strings.keys:
                        var modifier = "$"&item
                        functionName = functionName.replace(modifier, $(strings[item]))

                    for item in floats.keys:
                        var modifier = "$"&item
                        functionName = functionName.replace(modifier, $(floats[item]))

                    functionName = functionName.replace("\"", "")

                    discard timelib.runtime(functionName)

            if statement == "exit()":
                quit(1)
                    
        counter += 1

    return ""
