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

type_line 'micro example.cpp' 2s
type_line '#include "fmtlib.h"' 1s
type_line '#include <iostream>' 1s
xdotool key Enter
type_line 'using namespace std;' 1s
xdotool key Enter
type_line 'int main() {' 1s
type_line 'int a{15};'
type_line 'double b{1523.61};' 2s
xdotool key Enter
type_line 'cout << "Here is a boring old cout: a = " << a << ", b = " << b << "\n";' 2s
type_line 'fmt::print("And here is fmt::print: a = {}, b = {}\n", a, b);' 3s
xdotool key ctrl+s ctrl+q

type_line '# If I try to compile this, I am going to get an error' 2s
type_line 'g++ -o example example.cpp' 3s
type_line '# We must install the fmt library using the instructions at'
type_line '# https://ziotom78.github.io/tnds-tomasi-notebooks/' 3s

type_line 'curl https://ziotom78.github.io/tnds-tomasi-notebooks/install_fmt_library | sh'
sleep 3s

type_line 'ls' 3s

type_line '# Now the program should be compiled without errors' 1s
type_line 'g++ -o example example.cpp' 2s
type_line './example' 3s

type_line '# Nice!' 2s
type_line '# What about adding some colors now?' 3s

type_line 'micro example.cpp' 2s
xdotool key Down Down Down Down Down Down Down Down Down Down Down
xdotool key End Enter
sleep 2s
type_line 'fmt::print(fg(fmt::color::green) | fmt::emphasis::italic,'
xdotool key Tab
type_line '"Some color! a = {}, b = {}\n", a, b);' 3s
xdotool key BackSpace
type_line 'fmt::print("We highlight a: {} but not b: {}\n",'
xdotool key Tab
type_line 'fmt::styled(a, fg(fmt::color::yellow) | bg(fmt::color::violet)),'
type_line 'b); // No highlight for "b"' 3s
xdotool key ctrl+s ctrl+q

type_line 'g++ -o example example.cpp' 3s
type_line './example' 3s
