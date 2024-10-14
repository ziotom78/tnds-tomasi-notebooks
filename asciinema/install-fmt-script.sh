#!/bin/sh

readonly DELAY_MS=200
echo "Focus on the terminal window, you have 5 seconds:"
sleep 5s

type_line () {
    line="$1"
    delay=$2
    xdotool type --delay $DELAY_MS "$line"
    xdotool key Enter
    if [ "$delay" != "" ]; then
        sleep $delay
    fi
}

rm -f example.cpp

type_line 'micro example.cpp' 2s
type_line '#include "fmtlib.h"' 1s
xdotool key Enter
type_line 'using namespace std;' 1s
xdotool key Enter
type_line 'int main() {' 1s
type_line 'int a{15};'
type_line 'double b{1523.61};' 2s
xdotool key Enter
type_line 'fmt::println("a = {}, b = {}", a, b);' 3s
xdotool key ctrl+s ctrl+q

type_line '# If I try to compile this, I am going to get an error' 2s
type_line 'g++ -o example -std=c++20 -g3 example.cpp' 3s
type_line '# Install the fmt library using the instructions at'
type_line '# https://ziotom78.github.io/tnds-tomasi-notebooks/' 3s

type_line 'curl https://ziotom78.github.io/tnds-tomasi-notebooks/install_fmt_library | sh'
sleep s5

type_line 'ls' 3s

type_line '# Now the program should be compiled without errors' 1s
type_line 'g++ -o example -std=c++20 -g3 example.cpp' 2s
type_line './example' 3s

type_line '# Nice!' 2s
