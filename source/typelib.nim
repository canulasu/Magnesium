import std/strutils

proc types*(contentsx: string): string =

    var contents = contentsx.replace("+", "").replace(" ", "")

    try:
        discard parseInt(contents.strip())
        return "Int"
    except:
        discard

    try:
        discard parseFloat(contents.strip())
        return "Float"
    except:
        discard

    if contents.strip() == "True" or contents.strip() == "False":
        return "Boolean"

    else:
        return "String"