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

cd source
nim c magnesium.nim
mv magnesium ..
cd ..
mkdir bin
mv magnesium bin

echo "Done. Results can be found in the ./bin directory"