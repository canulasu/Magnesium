import urllib.request
import zipfile
import os
import shutil
import sys
import platform

if len(sys.argv) < 1:
    exit()

print("Welcome to the Magnesium Packaging Program")
print("")
print("Copyright (c) 2025 canulasu")
print("All rights reserved.")
print("")
print("Use this utility to package your Magnesium scripts into executable files.")
print("-------------------------------------------------------------------------")
print("PLEASE NOTE THAT THIS UTILITY NEEDS THE NIM COMPILER INSTALLED AND INCLUDED IN PATH ALONG WITH A STABLE NETWORK CONNECTION")
print("")

executable_path = os.getcwd()
filename = os.path.abspath(sys.argv[1])

try:
    shutil.rmtree("Build")
except: pass

os.mkdir("Build")
os.chdir("Build")

print("Downloading Magnesium Language source")

url = "https://github.com/canulasu/Magnesium/archive/refs/heads/main.zip"

with urllib.request.urlopen(url) as response, open("magnesium.zip", "wb") as file:
    data = response.read()
    file.write(data)

print("Downloading complete")
print("Extracting downloaded source")

with zipfile.ZipFile("magnesium.zip", "r") as file:
    file.extractall()

print("Source extracted")

os.chdir("Magnesium-main")
os.chdir("source")

shutil.copy(filename, os.getcwd())

print("Injecting custom payload into source")

contents = f'''
import parser
import interpreter
import os

const page = staticRead("{sys.argv[1]}")

discard interpret(parserepl(page))
'''

with open(sys.argv[1].replace(".mg", ".nim"), "w") as file:
    file.write(contents)

print("Payload injected.")

print("Compiling source with magnesium")

os.system(f"nim c {sys.argv[1].replace(".mg", ".nim")}")

if platform.system() == "Windows":
    shutil.move(sys.argv[1].replace(".mg", "")+".exe", executable_path)
else:
    shutil.move(sys.argv[1].replace(".mg", ""), executable_path)

os.chdir(executable_path)
shutil.rmtree("Build")

print("Done")
