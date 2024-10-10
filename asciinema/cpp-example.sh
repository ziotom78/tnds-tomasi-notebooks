#!/bin/sh

echo "Please focus the terminal window, you have 5 seconds…"
sleep 5s

# Create test.cpp
rm -f test.cpp include.h

xdotool type --delay 200 "vim test.cpp"
xdotool key Enter
sleep 1s

xdotool type "i"
sleep 0.1s
xdotool type --delay 200 '#include <iostream>'
xdotool key Enter
xdotool key Enter
sleep 2s
xdotool type --delay 200 'int f(int a, int b) {'
xdotool key Enter
xdotool type --delay 200 'int result{a + b};'
xdotool key Enter
xdotool type --delay 200 'return 3 * result;'
xdotool key Enter
xdotool type --delay 200 '}'
sleep 3s
xdotool key Enter
xdotool key Enter
xdotool type --delay 200 'int main() {'
xdotool key Enter
xdotool type --delay 200 'std::cout << f(3, 5) << "\n";'
xdotool key Enter
xdotool type --delay 200 '}'
sleep 3s
xdotool key Escape
xdotool type --delay 200 ":wq"
xdotool key Enter
sleep 1s

xdotool type --delay 200 'g++ -o test -g3 -Wall --pedantic -std=c++23 test.cpp'
xdotool key Enter
sleep 3s

xdotool type --delay 200 './test'
xdotool key Enter
sleep 3s

xdotool type --delay 200 'vim include.h'
xdotool key Enter
sleep 1s

xdotool type "i"
xdotool type --delay 200 'int f(int a, int b) {'
xdotool key Enter
sleep 1s

xdotool key Escape
xdotool type --delay 200 ":w"
xdotool key Enter
sleep 1s

xdotool type --delay 200 ":split"
xdotool key Enter
sleep 2s

xdotool type --delay 200 ":e test.cpp"
xdotool key Enter
sleep 1s

xdotool type --delay 750 "jj"
sleep 1s
xdotool type --delay 750 "Di"
sleep 1s
xdotool type --delay 200 '#include "include.h"'
sleep 5s
xdotool key Escape
xdotool type --delay 200 ":wq"
xdotool key Enter
sleep 2s
xdotool type --delay 200 ":q"
xdotool key Enter
sleep 2s

xdotool type --delay 200 'g++ -o test -g3 -Wall --pedantic -std=c++23 test.cpp'
xdotool key Enter
sleep 3s

xdotool type --delay 200 './test'
xdotool key Enter
sleep 3s

xdotool type --delay 200 "cpp test.cpp"
sleep 2s
xdotool key Enter
sleep 5s

