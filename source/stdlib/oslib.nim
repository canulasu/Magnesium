import os
import std/strutils

proc runtime*(command: string): string =
    if command.startsWith("system(") and command.endsWith(")"):
        when defined(windows):
            discard os.execShellCmd("powershell -Command " & command.replace("system(", "").replace(")", "").strip())
        else:
            discard os.execShellCmd(command.replace("system(", "").replace(")", "").strip())

    if command.startsWith("chdir(") and command.endsWith(")"):
        try:
            os.setCurrentDir(command.replace("chdir(", "").replace(")", "").strip())
        except:
            echo "Magnesium: Error! Could not change to specified directory because it does not exist."

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
    updated = updated.replace("~", os.getHomeDir())

    return updated
