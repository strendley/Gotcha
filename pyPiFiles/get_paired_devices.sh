#!/usr/bin/env bash

coproc bluetoothctl
echo -e 'devices' >&${COPROC[1]}
output=$(cat <&${COPROC[0]})
echo $output
