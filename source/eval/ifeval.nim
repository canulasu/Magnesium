import std/strutils

proc check*(expression: string): bool =
    var parsed = expression.replace("if ", "").strip().split("=")
    var final: seq[string] = @[]

    for item in parsed:
        final.add(item.strip())

    if final[0] == final[1]:
        return true
    else:
        return false