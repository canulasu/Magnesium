import std/strutils

proc evaluate*(expression: string): int =
    var parsed = expression.strip().replace(" ", "").split("+")
    var ans = 0
    for item in parsed:
        ans += parseInt(item)
    return ans

proc evaluate_float*(expression: string): float =
    var parsed = expression.strip().replace(" ", "").split("+")
    var ans = 0.0
    for item in parsed:
        ans += parseFloat(item)
    return ans