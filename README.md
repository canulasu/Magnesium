# Magnesium

### Summary
Magnesium is a lightweight scripting language aimed for fast, simple, and full featured development. The language aims to run without the overhead of a traditional VM (virtual machine) or an AST (abstract syntax tree) to reduce overhead. The language aims to be simple, user friendly, and versatile. Magnesium has syntax elements combined from a veriety of the most loved programming languages. Syntax is a combination/fusion of different languages such as Python, Bash, Java, and Fortran (or at least in spirit). The language is still in its early alpha development stages so feel free to downloads or try it but we would like to warn you that there may be stability issues or paring errors.

______

### Key features of Magnesium

- No virtual machine (uses a direct execution technique instead).
- Custom line-by-line parsing logic for less overhead.
- Support for external libraries and functions.
- Codebase is easy to work with and fork.
- Very fast execution times compared to other interpreted languages.

### Future projects and aspirations

We aim to create a built in bundling mechanism so you can package you Magnesium scripts into native executables using a custom compiled version of the Nim source. You can expect this feature in the next major update and we are working hard to bring it to you!

### Compiling Magnesium

We do not currently provide pre compiled packages for Magnesium, so you will need to compile it yourself. Thankfully, we have made this process very easy for you. If you are in a Unix based system, you can run the build.sh script you can find in our repository. For windows users, we do not yet have an automatic option but you can expect a PowerShell compilation script soon.

#### Please make sure you have the following dependencies installed on your system before compiling!

- Nim Language Compiler (Version 2+). -> [Link](https://nim-lang.org)