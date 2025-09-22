#!/bin/sh

readonly DELAY_MS=200
echo "Please focus the terminal window, you have 5 seconds…"
sleep 5s

# Create test.cpp
rm -f test.cpp include.h

xdotool type --delay $DELAY_MS "micro test.cpp"
xdotool key Enter
sleep 1s
xdotool type --delay $DELAY_MS '#include <print>'
xdotool key Enter Enter
xdotool type --delay $DELAY_MS 'using namespace std;'
xdotool key Enter Enter
sleep 1s
xdotool type --delay $DELAY_MS 'int f(int a, int b) {'
xdotool key Enter
xdotool type --delay $DELAY_MS 'int result{a + b};'
xdotool key Enter
xdotool type --delay $DELAY_MS 'return 3 * result;'
sleep 3s
xdotool key Down Enter
xdotool type --delay $DELAY_MS 'int main() {'
xdotool key Enter
xdotool type --delay $DELAY_MS 'println("Result = {}", f(3, 5));'
xdotool key Enter
xdotool type --delay $DELAY_MS 'return 0;'
sleep 3s
xdotool key ctrl+s ctrl+q
sleep 1s

xdotool type --delay $DELAY_MS 'g++ -o test -g3 -Wall -Wextra -Werror --pedantic -std=c++23 test.cpp'
xdotool key Enter
sleep 3s

xdotool type --delay $DELAY_MS './test'
xdotool key Enter
sleep 3s

xdotool type --delay $DELAY_MS 'micro include.h'
xdotool key Enter
sleep 1s

xdotool type --delay $DELAY_MS 'int f(int a, int b) {'
xdotool key Delete Delete Enter
sleep 1s
xdotool key ctrl+s
sleep 2s

xdotool key ctrl+e
xdotool type --delay $DELAY_MS "vsplit"
sleep 1s
xdotool key Enter

xdotool key ctrl+o
sleep 1s
xdotool type --delay $DELAY_MS "test.cpp"
sleep 1s
xdotool key Enter
sleep 1s

xdotool key Down Down Down Down
sleep 1s
xdotool key --delay DELAY_MS ctrl+k Enter Up
sleep 1s
xdotool type --delay $DELAY_MS '#include "include.h"'
sleep 3s
xdotool key ctrl+s ctrl+q
sleep 2s
xdotool key ctrl+q
sleep 2s

xdotool type --delay $DELAY_MS 'g++ -o test -g3 -Wall -Wextra -Werror --pedantic -std=c++23 test.cpp'
xdotool key Enter
sleep 3s

xdotool type --delay $DELAY_MS './test'
xdotool key Enter
sleep 3s

xdotool type --delay $DELAY_MS "cpp test.cpp"
sleep 2s
xdotool key Enter
sleep 5s
xdotool key ctrl+d

# Delete the temporary files created by this script
rm -f test test.cpp include.h
