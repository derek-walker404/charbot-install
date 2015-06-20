#!/bin/bash




# Need to install version 0.1.0 first
wget https://s3-us-west-1.amazonaws.com/charbot-dl/client/upgrade-0.1.0.sh
chmod upgrade-0.1.0.sh
grep -rl 'sudo reboot' upgrade-0.1.0.sh | xargs sed -i -e 's/sudo reboot/echo "Done..."/g'
rm upgrade-0.1.0.sh-e




LOG_FILE=upgrade-0.1.1.log
NOW=$(date)
echo $NOW > $LOG_FILE
echo 'Changing device.version to 0.1.1' >> $LOG_FILE
echo 'Testing auto-upgrade job' >> $LOG_FILE




# replace device version
grep -rl 'device.version = *' app.properties | xargs sed -i -e 's/device.version = .*$/device.version = 0.1.1/g'
rm app.properties-e




# clean up
rm upgrade-0.1.1.sh
sudo reboot
