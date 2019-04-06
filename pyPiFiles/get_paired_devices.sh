#!/usr/bin/expect -f

set prompt "#"

spawn sudo service bluetooth restart
sleep 1
spawn sudo bluetoothctl
sleep 1
expect -re $prompt
sleep 1

log_file paired_devices.log
sleep 1

send "devices\r"
sleep 1
expect -re $prompt

send "quit\r"
expect eof
