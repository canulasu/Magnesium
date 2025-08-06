import std/strutils
import os

proc runtime*(command: string): string =
    if command.strip().startsWith("sleep(") and command.endsWith(")"):
        sleep(parseInt(command.replace("sleep(", "").replace(")", "").strip())*1000)