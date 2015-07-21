#!/bin/bash




LOG_FILE=upgrade-0.1.5.log
NOW=$(date)
echo $NOW > $LOG_FILE
echo 'Changing device.version to 0.1.5' >> $LOG_FILE
echo 'Install new version of client' >> $LOG_FILE
echo '    - Adding randomized data to SST tests.' >> $LOG_FILE




# replace device version
wget https://s3-us-west-1.amazonaws.com/charbot-dl/client/charbox-client-0.1.5-SNAPSHOT.jar
grep -rl 'java -jar charbo*' charbot.sh | xargs sed -i -e 's/java -jar charbox.*$/java -jar charbox-client-0.1.5-SNAPSHOT.jar client \&/g'
rm charbot.sh-e




# append device version
grep -rl 'device.version = *' app.properties | xargs sed -i -e 's/device.version = .*$/device.version = 0.1.5/g'




# clean up
rm upgrade-0.1.5.sh
sudo reboot
