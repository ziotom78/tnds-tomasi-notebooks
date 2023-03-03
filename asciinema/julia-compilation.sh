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
type_line 'mysum(a, b) = a + b' 1s
type_line 'mysum(1, 2)' 2s
type_line 'mysum(1., 2.)' 2s
type_line 'mysum(1//2, 2//3)' 5s
type_line 'mysum(1. + 3.0im, 2. - 0.4im)' 5s

type_line '?@code_native' 8s

xdotool key BackSpace

type_line '@code_native mysum(1, 2)' 6s

type_line '@code_native mysum(1., 2.)' 6s

xdotool key ctrl+d

sleep 1s

xdotool key ctrl+d
