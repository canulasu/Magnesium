import std/strutils

proc find_arguments*(text: string, start: string, finish: string): seq[string] =
    var document = text.replace(start, "#seperator3092482342234#").replace(finish, "#seperator3092482342234#").split("#seperator3092482342234#")
    var ans: seq[string] = @[]

    for item in document:
        if item.strip() == "":
            discard
        else:
            ans.add(item)

    return ans