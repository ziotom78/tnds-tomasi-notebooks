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

type_line 'julia' 5s
type_line '# This is the REPL. We can write Julia code here' 2s
type_line 'function f(x)' 1s
type_line '3x^2   # We can avoid the "return": it is optional' 1s
type_line 'end' 2s
type_line 'f(3.6)' 2s
type_line '# We can define one-line functions with a nice shorthand:' 2s
type_line 'g(x) = 5x^2' 3s
type_line 'g(-5.1)' 2s
type_line '# We can use Unicode characters. To type ν and π, write \nu and \pi and press TAB:' 3s
xdotool type --delay $DELAY_MS 'g(t, \nu'
sleep 1s
xdotool key Tab
sleep 1s
xdotool type --delay $DELAY_MS ') = sin(2\pi'
sleep 1s
xdotool key Tab
sleep 1s
xdotool type --delay $DELAY_MS ' * t * \nu'
sleep 1s
xdotool key Tab
sleep 1s
type_line ')' 3s
type_line '# Lists are supported natively: no need to do #include <vector>' 2s
type_line 'x = Float64[1.0, 3.0, 4.0]' 2s
type_line '# We cannot apply scalar functions to lists of numbers…' 3s
type_line 'sin(x)' 3s
type_line '# …but we can use the dot "." to let Julia apply the function to every element' 3s
type_line 'sin.(x)' 3s
type_line '# Unlike C++, we can define new operators! Here is \oplus:' 3s
xdotool type --delay $DELAY_MS '\oplus'
sleep 1s
xdotool key Tab
sleep 1s
type_line '(x, y) = 2x + y' 2s
xdotool type --delay $DELAY_MS '3 \oplus'
xdotool key Tab
sleep 1s
type_line ' 2' 3s

xdotool key ctrl+d

sleep 1s

xdotool key ctrl+d
