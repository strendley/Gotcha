#!/usr/bin/expect -f

set prompt "#"

spawn sudo service bluetooth restart
sleep 1
spawn sudo bluetoothctl
sleep 1
expect -re $prompt
sleep 1

send "devices\r"
sleep 1
expect -re $prompt
set devices $expect_out(buffer)
puts $devices
sleep 1
send_user "Sdevices"


#send "quit\r"
expect eof
