#!/bin/sh

# shellcheck disable=SC2028

_="
---
args:
  - sh
---
"

wd=$(mktemp -d)

cd "$wd" || exit

echo '\n*** Interpreters ***\n'

# deno.land
echo 'await Deno.stdout.write(new TextEncoder().encode("TypeScript: Hello, World!\\n"))' >hello.ts
tea hello.ts

# go.dev
cat <<EOF >hello.go
package main
import "fmt"
func main() {
  fmt.Println("Go: Hello, World!")
}
EOF
tea hello.go

# nodejs.org
echo 'process.stdout.write("JavaScript: Hello, World!\\n")' >hello.js
tea hello.js

# perl.org
echo 'print "Perl: Hello, World!\\n"' >hello.pl
tea hello.pl

# python.org
echo 'print("Python: Hello, World!")' >hello.py
tea hello.py

# ruby-lang.org
echo 'puts "Ruby: Hello World!\\n"' >hello.rb
tea hello.rb

# lua.org
echo 'print("Lua: Hello, World!")' >hello.lua
tea hello.lua

echo '\n*** Compilers ***\n'

# tea.xyz/gx/cc
cat <<EOF >hello.c
#include <stdio.h>

int main(int argc, char *argv[]) {
  printf("C: Hello, World!\n");
  return 0;
}
EOF
tea +tea.xyz/gx/cc cc -o hello-c hello.c
./hello-c

# rust-lang.org
echo 'fn main() { println!("Rust: Hello, World!"); }' >hello.rs
tea -X rustc -o hello-rust hello.rs
./hello-rust

cd - >/dev/null || exit
rm -r "$wd"
