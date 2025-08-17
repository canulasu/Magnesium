import std/strutils
import tables
import typelib
import os
import parser
import length

import eval/inteval
import eval/ifeval

import stdlib/oslib
import stdlib/timelib
import stdlib/mathlib

import engines/rengine

proc interpret*(codeContent: string): string =

    var oslib_imported = false
    var timelib_imported = false
    var mathlib_imported = false

    var document = codeContent
    var libraries: seq[string] = @[]

    for line in codeContent.split("\n"):
        if line.startswith("include "):
            if line.strip() == "include os":
                oslib_imported = true
            elif line.strip() == "include time":
                timelib_imported = true
            elif line.strip() == "include math":
                mathlib_imported = true
            else:
                document = readFile(line.replace("include ", "") & ".mg") & "\n" & document
                libraries.add(line.replace("include ", "").strip())


    var functions: seq[string] = @[]
    var function_names: Table[string, int]

    var functioncounter = 0

    ########################################################

    var ifs: seq[string] = @[]
    var if_names: Table[string, int]

    var ifcounter = 0

    var whiles: seq[string] = @[]
    var while_names: Table[string, int]

    var whilecounter = 0

    var strings: Table[string, string]
    var floats: Table[string, float]
    var lists: Table[string, string]

    var globals: seq[string] = @[]

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
            if mathlib_imported == true:
                statement = mathlib.refresh(statement)

            # start main eval checks

            if statement.startsWith("var "):
                var name = statement.replace("var ", "").split("=")[0].strip()
                var contents = statement.replace("var ", "").split("=")[1].strip()
                var vartype = types(contents)

                if "prompt(" in contents:
                    var prompts = find_arguments(contents, "prompt(", ")")

                    for item in prompts:
                        var parsedItem = item.replace("\"", "")

                        stdout.write(parsedItem)
                        var question = readLine(stdin)

                        contents = contents.replace("prompt("&item&")", question)

                if contents.startswith("length(") and contents.endsWith(")"):
                    contents =contents.replace("\"", "").replace("length(")[0 ..^ 2]
                    floats[name] = length.length(contents, counter)
                    continue

                for item in strings.keys:
                    var modifier = "$"&item
                    contents = contents.replace(modifier, $(strings[item]))

                for item in floats.keys:
                    var modifier = "$"&item
                    contents = contents.replace(modifier, $(floats[item]))

                try:
                    contents = $(evaluate(contents))
                except:
                    discard

                if vartype == "String":
                    strings[name] = contents.replace("\"", "")
                else:
                    floats[name] = evaluate(contents)

            elif statement.startsWith("list "):
                var parsed = statement.replace("list ", "")
                var expression = parsed.split("=")
                
                for x in 0..len(expression)-1:
                    expression[x] = expression[x].strip()

                var name = expression[0]
                var contents = expression[1]

                var list = contents.replace("[", "").replace("]", "").split(",")

                for x in 0..len(list)-1:
                    list[x] = list[x].strip()

                for x in 0..len(list)-1:
                    var counter = $(x)
                    var iterName = name&"["&counter&"]"
                    lists[iterName] = list[x]

            elif statement.startsWith("global "):
                var name = statement.replace("global ", "").split("=")[0].strip()
                var contents = statement.replace("global ", "").split("=")[1].strip()
                var vartype = types(contents)

                if contents.startswith("prompt(") and contents.endsWith(")"):
                    contents =contents.replace("\"", "").replace("prompt(")[0 ..^ 2]
                    stdout.write(contents)
                    var value = readLine(stdin)
                    strings[name] = value
                    continue

                if contents.startswith("length(") and contents.endsWith(")"):
                    contents =contents.replace("\"", "").replace("length(")[0 ..^ 2]
                    floats[name] = length.length(contents, counter)
                    continue

                for item in strings.keys:
                    var modifier = "$"&item
                    contents = contents.replace(modifier, $(strings[item]))

                for item in floats.keys:
                    var modifier = "$"&item
                    contents = contents.replace(modifier, $(floats[item]))

                for item in lists.keys:
                    var modifier = "$"&item
                    contents = contents.replace(modifier, $(lists[item]))

                try:
                    contents = $(evaluate(contents))
                except:
                    discard

                if vartype == "String":
                    strings[name] = contents.replace("\"", "")
                else:
                    floats[name] = evaluate(contents)

                globals.add(statement)

            elif statement.startsWith("print"):
                var newline = false

                if statement.startsWith("println(") and statement.endsWith(")"):
                    newline = true
                
                elif statement.startsWith("print(") and statement.endsWith(")"):
                    newline = false

                var parameters = statement.replace("println(", "").replace("print(", "").replace(")", "").strip()

                for item in strings.keys:
                    var modifier = "$"&item
                    parameters = parameters.replace(modifier, $(strings[item]))

                for item in floats.keys:
                    var modifier = "$"&item
                    parameters = parameters.replace(modifier, $(floats[item]))

                for item in lists.keys:
                    var modifier = "$"&item
                    parameters = parameters.replace(modifier, $(lists[item]))

                try:

                    if newline == true:
                        echo evaluate(parameters.replace("\"", ""))
                    else:
                        stdout.write(evaluate(parameters.replace("\"", "")))

                except:
                    if newline == true:
                        echo parameters.replace("\"", "")
                    else:
                        stdout.write(parameters.replace("\"", ""))

            elif statement.startsWith("exec(") and statement.endsWith(")"):
                var parameters = statement.replace("exec(", "").strip()[0 ..^ 2]

                for item in strings.keys:
                    var modifier = "$"&item
                    parameters = parameters.replace(modifier, $(strings[item]))

                for item in floats.keys:
                    var modifier = "$"&item
                    parameters = parameters.replace(modifier, $(floats[item]))

                for item in lists.keys:
                    var modifier = "$"&item
                    parameters = parameters.replace(modifier, $(lists[item]))

                try:
                    discard interpret(parserepl($(evaluate(parameters.replace("\"", "")))))
                except:
                    discard interpret(parserepl($(parameters.replace("\"", ""))))
                    
            elif statement.startsWith("function "):
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

                for item in globals:
                    functioncontent.add(item)

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


            elif statement.startsWith("if "):
                var name = statement.strip().replace("if ", "").replace("()", "").replace("{", "").strip()

                for item in strings.keys:
                    var modifier = "$"&item
                    name = name.replace(modifier, $(strings[item]))

                for item in floats.keys:
                    var modifier = "$"&item
                    name = name.replace(modifier, $(floats[item]))

                for item in lists.keys:
                    var modifier = "$"&item
                    name = name.replace(modifier, $(lists[item]))

                if_names[name] = ifcounter

                var index = code.find(statement)
                var ifcontent: seq[string] = @[]

                if oslib_imported == true:
                    ifcontent.add("include os")
                if timelib_imported == true:
                    ifcontent.add("include time")

                for item in libraries:
                    ifcontent.add("include " & item)

                for item in globals:
                    ifcontent.add(item)

                for i in index + 1 ..< code.len:

                    var line = code[i]

                    var check = line.replace(":*#$?!>-+ ", "").strip()

                    if  "}" in check.strip().split():
                        break
                    if check.strip() == "{":
                        discard
                    else:
                        ifcontent.add(check)
                        forbidden.add(i)

                ifs.add(ifcontent.join("\n"))

                ifcounter += 1

                if check(name) == true:
                    discard interpret(ifs[if_names[name]])
                else:
                    discard

            elif statement.startsWith("while "):
                var name = statement.strip().replace("while ", "").replace("()", "").replace("{", "").strip()

                for item in strings.keys:
                    var modifier = "$"&item
                    name = name.replace(modifier, $(strings[item]))

                for item in floats.keys:
                    var modifier = "$"&item
                    name = name.replace(modifier, $(floats[item]))

                for item in lists.keys:
                    var modifier = "$"&item
                    name = name.replace(modifier, $(lists[item]))

                while_names[name] = whilecounter

                var index = code.find(statement)
                var whilecontent: seq[string] = @[]

                if oslib_imported == true:
                    whilecontent.add("include os")
                if timelib_imported == true:
                    whilecontent.add("include time")

                for item in libraries:
                    whilecontent.add("include " & item)

                for item in globals:
                    whilecontent.add(item)

                for i in index + 1 ..< code.len:

                    var line = code[i]

                    var check = line.replace(":*#$?!>-+ ", "").strip()

                    if check.strip().startsWith("global "):
                        globals.add(check.strip())

                    if  "}" in check.strip().split():
                        break
                    if check.strip() == "{":
                        discard
                    else:
                        whilecontent.add(check)
                        forbidden.add(i)

                whiles.add(whilecontent.join("\n"))

                whilecounter += 1

                while check(name) == false:
                    discard interpret(whiles[while_names[name]])

            elif statement.startsWith("call "):
                var name = statement.strip().replace("call ", "").replace("()", "").replace("{", "").strip()

                try:
                    discard interpret(functions[function_names[name]])
                except:
                    echo "Magnesium: Error on line " & $(counter) & ". Function does not exist."
                    quit(1)

            elif statement.startsWith("os."):
                discard
            elif statement.startsWith("time."):
                discard
            elif statement.startsWith("math."):
                discard
                
            elif statement.startswith("include "):
                discard

            elif statement.startswith("//"):
                discard
            elif "}" in statement:
                discard
            elif statement == "":
                discard
            elif statement == "exit()":
                quit(1)

            else:
                echo "Error: invalid command: " & statement
                quit(1)

            if oslib_imported == true:
                if statement.startsWith("os."):
                    var functionName = statement.replace("os.", "")

                    for item in strings.keys:
                        var modifier = "$"&item
                        functionName = functionName.replace(modifier, $(strings[item]))

                    for item in floats.keys:
                        var modifier = "$"&item
                        functionName = functionName.replace(modifier, $(floats[item]))

                    for item in lists.keys:
                        var modifier = "$"&item
                        functionName = functionName.replace(modifier, $(lists[item]))

                    functionName = functionName.replace("\"", "")

                    discard oslib.runtime(functionName)

            if timelib_imported == true:
                if statement.startsWith("time."):
                    var functionName = statement.replace("time.", "")

                    for item in strings.keys:
                        var modifier = "$"&item
                        functionName = functionName.replace(modifier, $(strings[item]))

                    for item in floats.keys:
                        var modifier = "$"&item
                        functionName = functionName.replace(modifier, $(floats[item]))

                    for item in lists.keys:
                        var modifier = "$"&item
                        functionName = functionName.replace(modifier, $(lists[item]))

                    functionName = functionName.replace("\"", "")

                    discard timelib.runtime(functionName)

            if statement == "exit()":
                quit(1)
                    
        counter += 1

    return ""
