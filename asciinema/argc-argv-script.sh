#!/bin/sh

readonly DELAY_MS=300
echo "Focus on the terminal window, you have 5 seconds:"
sleep 5s

xdotool type --delay $DELAY_MS 'micro args-example.cpp'
xdotool key Enter
sleep 3s
xdotool type --delay $DELAY_MS '#include <iostream>'
xdotool key Enter Enter
xdotool type --delay $DELAY_MS 'using namespace std;'
xdotool key Enter Enter
xdotool type --delay $DELAY_MS 'int main(int argc, char *argv[]) {'
xdotool key Enter
xdotool type --delay $DELAY_MS 'cout << "argc = " << argc << "\n";'
xdotool key Enter
sleep 3s
xdotool type --delay $DELAY_MS 'for (int i = 0; i < argc; ++i) {'
xdotool key Enter
sleep 3s
xdotool type --delay $DELAY_MS 'cout << "argv[" << i << "] = " << argv[i] << "\n";'
sleep 3s
xdotool key Enter ctrl+s ctrl+q
xdotool type --delay $DELAY_MS 'g++ -o args-example args-example.cpp'
xdotool key Enter
sleep 2s
xdotool type --delay $DELAY_MS './args-example'
xdotool key Enter
sleep 3s
xdotool type --delay $DELAY_MS './args-example 10'
xdotool key Enter
sleep 3s
xdotool type --delay $DELAY_MS './args-example 10 ../data.dat'
xdotool key Enter
sleep 3s
xdotool type --delay $DELAY_MS 'rm -f args-example.cpp args-example'
xdotool key Enter
xdotool key ctrl+d
