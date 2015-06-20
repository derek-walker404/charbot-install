#!/bin/bash




# Need to install version 0.1.0 first
wget https://s3-us-west-1.amazonaws.com/charbot-dl/client/upgrade-0.1.0.sh
chmod +x upgrade-0.1.0.sh
grep -rl 'sudo reboot' upgrade-0.1.0.sh | xargs sed -i -e 's/sudo reboot/echo "Done..."/g'
rm upgrade-0.1.0.sh-e
./upgrade-0.1.0.sh




LOG_FILE=upgrade-0.1.2.log
NOW=$(date)
echo $NOW > $LOG_FILE
echo 'Changing device.version to 0.1.2' >> $LOG_FILE
echo 'Install new version of client' >> $LOG_FILE
echo '    - Additional Logging to help detect infinite hanging speed tests.' >> $LOG_FILE




# replace device version
wget https://s3-us-west-1.amazonaws.com/charbot-dl/client/charbox-client-0.1.1-SNAPSHOT.jar
grep -rl 'java -jar charbo*' charbot.sh | xargs sed -i -e 's/java -jar charbox.*$/java -jar charbox-client-0.1.1-SNAPSHOT.jar client \&/g'
rm charbot.sh-e




# replace device version
grep -rl 'device.version = *' app.properties | xargs sed -i -e 's/device.version = .*$/device.version = 0.1.2/g'
rm app.properties-e




# clean up
rm upgrade-0.1.2.sh
sudo reboot
