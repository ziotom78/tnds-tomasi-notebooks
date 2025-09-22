#!/bin/sh

readonly DELAY_MS=200
echo "Focus on the terminal window, you have 5 seconds:"
sleep 5s

xdotool type --delay $DELAY_MS 'micro args-example.cpp'
xdotool key Enter
sleep 3s
xdotool type --delay $DELAY_MS '#include <print>'
xdotool key Enter Enter
xdotool type --delay $DELAY_MS 'using namespace std;'
xdotool key Enter Enter
xdotool type --delay $DELAY_MS 'int main(int argc, char *argv[]) {'
xdotool key Enter
xdotool type --delay $DELAY_MS 'println("argc = {0}", argc);'
xdotool key Enter
sleep 3s
xdotool type --delay $DELAY_MS 'for (int i{}; i < argc; ++i) {'
xdotool key Enter
sleep 3s
xdotool type --delay $DELAY_MS 'println("argv[{0}] = \"{1}\"", i, argv[i]);'
sleep 3s
xdotool key Down Enter
xdotool type --delay $DELAY_MS 'return 0;'
sleep 3s
xdotool key ctrl+s ctrl+q
xdotool type --delay $DELAY_MS 'g++ -o args-example -std=c++23 -Wall -Wextra -Werror --pedantic args-example.cpp'
xdotool key Enter
sleep 2s
xdotool type --delay $DELAY_MS './args-example'
xdotool key Enter
sleep 3s
xdotool type --delay $DELAY_MS './args-example 10'
xdotool key Enter
sleep 3s
xdotool type --delay $DELAY_MS './args-example 10 1941.txt'
xdotool key Enter
sleep 3s
xdotool key Enter
xdotool key ctrl+d

# Delete all the leftovers
rm -f args-example.cpp args-example
