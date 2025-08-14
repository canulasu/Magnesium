import std/strutils
import sequtils

proc evaluate*(expression: string): float =
    var parsed = expression

    parsed = parsed.replace("+", " + ")
    parsed = parsed.replace("-", " - ")
    parsed = parsed.replace("*", " * ")
    parsed = parsed.replace("/", " / ")

    var command = parsed.split()
    var final: seq[string] = @[]

    for item in command:
        if item != "":
            final.add(item)

    var base = parseFloat(final[0])
    var counter = 0

    for item in final:
        if item == "+":
            base += parseFloat(final[counter + 1])
        elif item == "-":
            base -= parseFloat(final[counter + 1])
        elif item == "/":
            base = base / parseFloat(final[counter + 1])
        elif item == "*":
            base = base * parseFloat(final[counter + 1])

        counter += 1

    return base

proc evaluate_float*(expression: string): float =
    var parsed = expression.strip().replace(" ", "").split("+")
    var ans = 0.0
    for item in parsed:
        ans += parseFloat(item)
    return ans