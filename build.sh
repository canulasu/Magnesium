#!/bin/sh

set -e

if command -v nim; then
    echo "Nim Compiler Installed On System"
    echo "Proceeding to compile"
else
    echo "Error: The Nim language compiler is not installed on this system"
    echo "Error: Please install it to continue"
    exit
fi

if command -v python; then
    echo "Python Installed On System"
    echo "Proceeding to compile"
else
    if command -v python3; then
        echo "Python Installed On System"
        echo "Proceeding to compile"
    else
        echo "Error: Python is not installed on this system"
        echo "Error: Please install it to continue"
        exit
    fi
fi


if command -v pyinstaller; then
    echo "Pyinstaller Installed On System"
    echo "Proceeding to compile"
else
    echo "Error: The Pyinstaller packaging tool is not installed on this system"
    echo "Error: Please install it to continue"
    exit
fi

cd source
nim c magnesium.nim
mv magnesium ..
cd ..
mkdir bin
mv magnesium bin

cd magpack
pyinstaller --onefile magpack.py
rm -rf magpack.spec build
cd source
mv magpack ..
cd ..
mv magpack ../bin

echo "Done. Results can be found in the ./bin directory"
