#!/usr/bin/expect -f

set prompt "#"

#spawn sudo service bluetooth restart
sleep 1
spawn sudo bluetoothctl
sleep 1
expect -re $prompt
sleep 1

send "discoverable yes\r"
sleep 1
expect "Changing discoverable on succeeded"
expect -re $prompt
sleep 1

send "agent on\r"
sleep 1
expect "Agent registered"
expect -re $prompt
sleep 2

send "default-agent\r"
sleep 2
expect "Default agent request successful"
expect -re $prompt
expect "Request confirmation"
expect "(yes/no):" {send "yes\r"}

send "quit\r"
expect eof
