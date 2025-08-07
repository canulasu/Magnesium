# Magnesium™

Official website: https://magnesium.42web.io

### Summary
Magnesium is a lightweight scripting language aimed for fast, simple, and full featured development. The language aims to run without the overhead of a traditional VM (virtual machine) or an AST (abstract syntax tree) to reduce overhead. The language aims to be simple, user friendly, and versatile. Magnesium has syntax elements combined from a veriety of the most loved programming languages. Syntax is a combination/fusion of different languages such as Python, Bash, Java, and Fortran (or at least in spirit). The language is still in its early alpha development stages so feel free to downloads or try it but we would like to warn you that there may be stability issues or paring errors.

Magnesium is still in its early development stages and features such as loops, if statements, and arithmetic (except addition) are yet not included. Nevertheless, it is a growing language and most (if not all) of these features will me implemented in the future.

______

### Key features of Magnesium

- No virtual machine (uses a direct execution technique instead).
- Custom line-by-line parsing logic for less overhead.
- Support for external libraries and functions.
- Codebase is easy to work with and fork.
- Very fast execution times compared to other interpreted languages.
- Can be packaged into native executables using our own MagPack tool.

### Compiling Magnesium

We do not currently provide pre compiled packages for Magnesium, so you will need to compile it yourself. Thankfully, we have made this process very easy for you. If you are in a Unix based system, you can run the build.sh script you can find in our repository. For windows users, we do not yet have an automatic option but you can expect a PowerShell compilation script soon. You can compile the ./source/magnesium.nim entry file using the Nim lang C or C++ backend, and the ./magpack/magpack.py utility can be run directly or packaged using Pyinstaller.

#### Please make sure you have the following dependencies installed on your system before compiling!

##### For main language
- Nim Language Compiler (Version 2+). -> [Link](https://nim-lang.org)
##### For the Magpack packaging tool
- Python3 (Version 3.12+ is recommended but versions 3.9+ will most likely work.) -> [Link](https://python.org)
- Pyinstaller -> [Link](https://pyinstaller.org)

The following names are unregistered trademarks for canulasu.
- Magnesium™ 
- Magnesium Language™
- Magnesium Scripting™
- .mg™
These marks are used to identify the official software and materials developed by canulasu.
Unauthorized use that may casue confusion of imply affiliation is not permitted.
