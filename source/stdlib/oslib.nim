import os
import std/strutils

proc runtime*(command: string): string =
    if command.startsWith("system(") and command.endsWith(")"):
        discard os.execShellCmd(command.replace("system(", "").replace(")", "").strip())

    elif command.startsWith("new(") and command.endsWith(")"):
        writeFile(command.replace("new(", "").replace(")", "").strip(), "")

    elif command.startsWith("write(") and command.endsWith(")"):
        var arguments = command.replace("write(", "").replace(")", "").strip()

        var contents = arguments.split(":")[1]
        var file = arguments.split(":")[0]
        writeFile(file, contents)

proc refresh*(command: string): string =
    var updated = command

    updated = updated.replace("os.path()", os.getCurrentDir())

    return updated
